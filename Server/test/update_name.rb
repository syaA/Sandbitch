#!/usr/bin/ruby

require_relative 'test_method'

test_method(:PUT, "/user/#{ARGV[0]}/name",
  %Q({\\"key\\":\\"#{ENV['SANDBITCH_DEV_API_KEY']}\\",\\"name\\":\\"#{ARGV[1]}\\"}))
