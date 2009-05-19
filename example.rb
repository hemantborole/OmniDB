#!/usr/bin/ruby

require 'lib/write'
if ARGV.length == 2
	key = ARGV[0]
	value = ARGV[1]

	p "Adding entry with key => #{key} and value => #{value}"
	w = Writer.new
	w.atomic_write(key, value)
else
	puts "Usage: example.rb <key> <value>"
end
