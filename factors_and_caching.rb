#!/usr/bin/env ruby
require 'yaml'

CACHE_FILE = "factor_cache.yml"
REVERSE_CACHE_FILE = "reverse_factor_cache.yml"

input = ARGV.map { |e| e.to_i }

cache = YAML::load_file CACHE_FILE if File.exist? CACHE_FILE
cache ||= {}

reverse_cache = YAML::load_file CACHE_FILE if File.exist? CACHE_FILE
reverse_cache ||= {}

cache[input] ||= Hash[input.map { |num| [num, input.select { |n| n != num && num.fdiv(n) == num.div(n)}] }]

reverse_cache[input] ||= Hash[input.map { |num| [num, input.select { |n| n != num && n.fdiv(num) == n.div(num)}] }]

File.open(CACHE_FILE, "w") do |file|
  file.write cache.to_yaml
end

File.open(REVERSE_CACHE_FILE, "w") do |file|
  file.write reverse_cache.to_yaml
end

puts cache[input]
puts reverse_cache[input]