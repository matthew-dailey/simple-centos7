#!/usr/bin/env ruby

# This script simply pulls in your public key to data_bags/public_keys/developer.json so that it
# can be used by kitchen.

require 'json'

public_key_file = ARGV[0]
if ARGV.empty?
    puts "Usage: #{File.basename($0)} public_key_files..."
    exit 1
end

public_keys = []
ARGV.each do |public_key_file|
    if !public_key_file.end_with?('.pub')
        puts "File #{public_key_file} doesn't end with .pub, so cautiously going to fail..."
        exit 2
    end
    File.readlines(public_key_file).each do |line|
        public_keys.push(line.strip())
    end
end

output_hash = {'id' => 'developer', 'public_keys' => public_keys}
output_json = JSON.pretty_generate(output_hash)

source_root = File.dirname($0)
output_file = File.join(source_root, 'data_bags', 'public_keys', 'developer.json')
File.open(output_file, 'w') do |file|
    file.write(output_json)
end
puts "Wrote to #{output_file}"
