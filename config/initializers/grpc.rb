# frozen_string_literal: true

$LOAD_PATH.unshift Rails.root.join("lib").to_s
$LOAD_PATH.unshift Rails.root.join("lib/proto").to_s
require "proto/books_pb"
require "proto/books_services_pb"
