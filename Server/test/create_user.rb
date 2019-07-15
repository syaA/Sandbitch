#!/usr/bin/ruby

require_relative 'test_method'

test_method(:POST, "/user", %Q({\\"key\\":\\"#{ENV['SANDBITCH_DEV_API_KEY']}\\"}))
