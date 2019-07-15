#!/usr/bin/ruby

require_relative 'test_method'

test_method(:GET, "/user/#{ARGV[0]}/ranking")
