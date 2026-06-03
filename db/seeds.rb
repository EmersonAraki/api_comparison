# frozen_string_literal: true

ursula = Author.find_or_create_by!(name: "Ursula K. Le Guin") do |a|
  a.bio = "American author of speculative fiction."
end

Book.find_or_create_by!(title: "The Left Hand of Darkness") do |b|
  b.published_year = 1969
  b.author = ursula
end

Book.find_or_create_by!(title: "The Dispossessed") do |b|
  b.published_year = 1974
  b.author = ursula
end
