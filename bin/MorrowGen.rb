#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/CharacterGenerator'

if ARGV.size < 2
  raise ArgumentError,
        "You must provide 2 arguments for gender and race (in order), you provided #{ARGV.size}:\n\nEx: \"ruby MorrowGen.rb male argonian\""
end

cb = ClassGenerator.new('../data/classes.yml')
sb = StatsGenerator.new('../data/stats.yml', '../data/birthsigns.yml')
nd = NameGenerator.new('../data/names.yml')
C = Character.new(ARGV[1], ARGV[0], nd, sb, cb)

puts C
