# API Comparison: REST vs GraphQL vs gRPC

A Rails 8 learning project that exposes the same four operations on Books and Authors through three different API protocols side-by-side. The goal is to make the differences between REST, GraphQL, and gRPC concrete and runnable.

## What it does

The app has two models — `Author` and `Book` — and four operations:

- List all books
- Get a single book
- Create a book
- Create an author

Every protocol implements all four operations by calling the same shared service objects. The business logic lives once; only the transport layer differs.

## How to run

### With Docker (recommended)

**Prerequisites:** Docker and Docker Compose

```bash
docker compose up --build
```

That's it. Compose starts three containers in the right order:

1. **postgres** — waits until healthy
2. **web** — runs `db:create db:migrate`, then starts Puma on port 3000
3. **grpc** — waits for web to be healthy, then starts the gRPC server on port 50051

To stop everything:

```bash
docker compose down
```

To wipe the database volume too:

```bash
docker compose down -v
```

### Without Docker

**Prerequisites:** Ruby 4.x, PostgreSQL, Bundler, Foreman

```bash
bundle install
bundle exec rails db:create db:migrate
gem install foreman
foreman start
```

This starts two processes:

| Process | Port | Protocol |
|---------|------|----------|
| Rails (Puma) | 3000 | REST + GraphQL |
| gRPC server | 50051 | gRPC |

---

## REST

REST uses HTTP verbs and URL paths to identify resources and actions.

**Endpoints:**

```
GET    /api/v1/books          List all books
GET    /api/v1/books/:id      Get a single book
POST   /api/v1/books          Create a book
POST   /api/v1/authors        Create an author
```

**Try it:**

```bash
# Create an author
curl -X POST http://localhost:3000/api/v1/authors \
  -H 'Content-Type: application/json' \
  -d '{ "name": "Ursula K. Le Guin", "bio": "American author of speculative fiction." }'

# Create a book (replace author_id with the id from the response above)
curl -X POST http://localhost:3000/api/v1/books \
  -H 'Content-Type: application/json' \
  -d '{ "title": "The Left Hand of Darkness", "published_year": 1969, "author_id": 1 }'

# List all books
curl http://localhost:3000/api/v1/books

# Get a single book
curl http://localhost:3000/api/v1/books/1
```

**Error responses:**

- `404` with `{ "error": "Not found" }` when a book does not exist
- `422` with `{ "errors": ["Title can't be blank"] }` on validation failure

---

## GraphQL

GraphQL uses a single endpoint (`POST /graphql`) and a typed query language. The client specifies exactly which fields it wants, and the server returns only those fields — nothing more.

**Endpoint:** `POST /graphql`

**Schema:**

```graphql
type Query {
  books: [Book!]!
  book(id: ID!): Book
}

type Mutation {
  createBook(input: CreateBookInput!): BookPayload!
  createAuthor(input: CreateAuthorInput!): AuthorPayload!
}
```

**Try it:**

```bash
# List all books, requesting only title and author name
curl -X POST http://localhost:3000/graphql \
  -H 'Content-Type: application/json' \
  -d '{
    "query": "{ books { id title author { name } } }"
  }'

# Get a single book
curl -X POST http://localhost:3000/graphql \
  -H 'Content-Type: application/json' \
  -d '{
    "query": "query($id: ID!) { book(id: $id) { title publishedYear author { name } } }",
    "variables": { "id": "1" }
  }'

# Create an author
curl -X POST http://localhost:3000/graphql \
  -H 'Content-Type: application/json' \
  -d '{
    "query": "mutation($name: String!, $bio: String) { createAuthor(input: { name: $name, bio: $bio }) { author { id name } errors } }",
    "variables": { "name": "Ursula K. Le Guin", "bio": "American author of speculative fiction." }
  }'

# Create a book
curl -X POST http://localhost:3000/graphql \
  -H 'Content-Type: application/json' \
  -d '{
    "query": "mutation($title: String!, $publishedYear: Int!, $authorId: ID!) { createBook(input: { title: $title, publishedYear: $publishedYear, authorId: $authorId }) { book { id title } errors } }",
    "variables": { "title": "The Left Hand of Darkness", "publishedYear": 1969, "authorId": "1" }
  }'
```

**Error responses:** Errors are returned inside the response body. HTTP status is always `200`. Schema validation errors appear under `errors` at the top level; business validation errors appear inside the mutation payload under `errors`.

---

## gRPC

gRPC uses binary-encoded messages (Protocol Buffers) over HTTP/2. The API is defined in a `.proto` file as a strongly typed service contract. Testing gRPC from the command line requires a tool like `grpcurl`.

**Install grpcurl:**

```bash
brew install grpcurl
```

**Service definition** (`protos/books.proto`):

```proto
service BookService {
  rpc ListBooks    (ListBooksRequest)    returns (ListBooksResponse);
  rpc GetBook      (GetBookRequest)      returns (BookResponse);
  rpc CreateBook   (CreateBookRequest)   returns (BookResponse);
  rpc CreateAuthor (CreateAuthorRequest) returns (AuthorResponse);
}
```

**Try it:**

```bash
# Create an author
grpcurl -plaintext \
  -d '{ "name": "Ursula K. Le Guin", "bio": "American author of speculative fiction." }' \
  localhost:50051 bookshelf.BookService/CreateAuthor

# Create a book (replace author_id with the id from the response above)
grpcurl -plaintext \
  -d '{ "title": "The Left Hand of Darkness", "published_year": 1969, "author_id": "1" }' \
  localhost:50051 bookshelf.BookService/CreateBook

# List all books
grpcurl -plaintext -d '{}' \
  localhost:50051 bookshelf.BookService/ListBooks

# Get a single book
grpcurl -plaintext -d '{ "id": "1" }' \
  localhost:50051 bookshelf.BookService/GetBook
```

**Error responses:** gRPC uses status codes instead of HTTP codes. This service returns `NOT_FOUND` for missing records and `INVALID_ARGUMENT` for validation failures.

---

## Protocol comparison

| | REST | GraphQL | gRPC |
|---|---|---|---|
| Transport | HTTP/1.1 | HTTP/1.1 | HTTP/2 |
| Format | JSON | JSON | Binary (Protocol Buffers) |
| Endpoint | Many URLs | One URL | Method calls |
| Schema | Informal (OpenAPI optional) | Strongly typed, introspectable | Strongly typed (`.proto` file) |
| Field selection | Server decides | Client decides | Server decides |
| Errors | HTTP status codes | Errors in response body | gRPC status codes |
| Tooling | curl, browsers, any HTTP client | GraphiQL, Postman | grpcurl, generated clients |
| Best for | Public APIs, simple CRUD | Complex queries, multiple clients | Internal services, high performance |

### Why choose REST?

REST is the default choice for public-facing APIs. Every HTTP client speaks it, browsers understand it natively, and the conventions (GET = read, POST = create, 404 = not found) are universally understood. The downside is that the server controls what data is returned — if a client only needs the book title, it still receives the full object.

### Why choose GraphQL?

GraphQL lets clients ask for exactly the fields they need. This is most valuable when you have multiple clients (web, mobile, third-party) with different data requirements, or when fetching related data would otherwise require multiple round trips. The tradeoff is complexity: a schema must be maintained, and queries can be expensive if not carefully designed.

### Why choose gRPC?

gRPC is optimized for service-to-service communication. Binary encoding is faster and smaller than JSON. The `.proto` contract is a strict interface definition that generates client code in any supported language automatically. It requires HTTP/2 and is harder to call from a browser or with simple tools — it is not a good choice for public APIs but excels for internal microservices where performance matters.

---

## Project structure

```
app/
  models/              Author, Book (shared by all protocols)
  services/            Books::{List,Find,Create}Service, Authors::CreateService
  controllers/api/v1/  REST controllers
  controllers/         GraphqlController
  graphql/             Schema, types, mutations
  grpc/                BookServiceImpl
config/
  routes.rb            REST routes + /graphql endpoint
  initializers/grpc.rb Loads generated proto stubs
lib/
  proto/               Generated Ruby gRPC stubs
  grpc_server.rb       Standalone gRPC server process
protos/
  books.proto          gRPC service definition
spec/
  models/              Model validation specs
  services/            Service object unit specs
  requests/            REST request specs
  graphql/             GraphQL type and mutation specs
  grpc/                gRPC service unit specs
```

## Running tests

```bash
bundle exec rspec
```

35 examples covering all three protocol layers.

---

## Notes

**CORS:** Cross-origin requests from a browser are blocked by default. `config/initializers/cors.rb` has a commented-out `rack-cors` configuration. Uncomment it (and add `gem 'rack-cors'` to the Gemfile) if you want to call these APIs from a frontend app.

**Seeds:** Run `bin/rails db:seed` (or `docker compose exec web bin/rails db:seed`) to load a sample author and two books so the README curl examples work immediately.
