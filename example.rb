#!/usr/bin/ruby
require 'lib/write'

def test1
  if ARGV.length == 2
    key = ARGV[0]
    value = ARGV[1]
    begin
      p "Adding entry with key => #{key} and value => #{value} for default time"
      w = Writer.new
      w.atomic_write(key, value)
      p "Getting value from cache : #{DHTCache.hash_out(key)}"
    rescue Exception => e
      p "Ex, the object is already in database, ignoring database write"
      p e.message
    end
  else
    puts "Usage: example.rb <key> <value>"
  end
end

def test2
  if ARGV.length == 2
    key = ARGV[0]
    value = ARGV[1]
    begin
      p "Adding entry with key => #{key} and value => #{value} for 2 seconds"
      w = Writer.new
      w.atomic_write(key, value, 2)
    rescue Exception => e
      p "Probably the object is already in database, ignoring database write"
      p e.message
    end

    p "Getting value from cache : #{DHTCache.hash_out(key)}"
    p "Sleeping for 2 seconds..."
    sleep 2
    p "Trying to fetch value from cache ..."
    vv = DHTCache.hash_out(key)
    if vv
      p "Got #{DHTCache.hash_out(key)}"
    else
      p "Got nothing, falling back to original store..."
      ## TODO - Add fetching from storage logic.
    end

  else
    puts "Usage: example.rb <key> <value>"
  end
end

#Writer.new.refill
test2
