#!/usr/bin/ruby

require_relative 'test_method'

test_method(:GET, "/ranking/#{ARGV[0]}")
