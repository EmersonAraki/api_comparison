# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "development"
require_relative "../config/environment"
server = GRPC::RpcServer.new
server.add_http2_port("0.0.0.0:50051", :this_port_is_insecure)
server.handle(BookServiceImpl)

Rails.logger.info "gRPC server running on port 50051"
server.run_till_terminated_or_interrupted([ 1, "int", "SIGTERM" ])
