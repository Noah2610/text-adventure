#!/usr/bin/env ruby

require "encrypt"
require "awesome_print"

file = ARGV[0]
password = File.read("./src/.password")

if (File.exists? file)
	ap eval(Encrypt.load(File.read(file), password))
else
	puts "#{file} doesn't exist."
	exit
end

