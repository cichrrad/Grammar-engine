#!/usr/bin/env ruby
# frozen_string_literal: true

require 'tty-prompt'
require 'tty-box'
require_relative '../lib/CharacterGenerator'

data_dir = File.join(__dir__, '../data')

sb = StatsGenerator.new(File.join(data_dir, 'stats.yml'), File.join(data_dir, 'birthsigns.yml'))
cb = ClassGenerator.new(File.join(data_dir, 'classes.yml'))
nd = NameGenerator.new(File.join(data_dir, 'names.yml'))

prompt = TTY::Prompt.new

def clear_screen
  print "\033[2J\033[H" # ANSI clear screen code
end

# 4. Main Loop
loop do
  clear_screen
  prompt.say "\n"
  prompt.say 'Welcome to the Morrowind Character Generator', color: :cyan

  # Gender
  gender = prompt.select('Choose your gender:', %w[Male Female])

  # Race
  # We fetch the race keys dynamically from the StatsGenerator we already loaded
  # .map(&:capitalize) makes them look nice in the menu
  race_options = sb.races.keys.map(&:capitalize).sort
  race = prompt.select('Choose your race:', race_options)

  character = Character.new(race, gender, nd, sb, cb)

  # --- Output ---
  box = TTY::Box.frame(
    border: :thick,
    title: { top_left: ' CHARACTER ' },
    padding: 1
  ) do
    character.to_s
  end

  print "\n"
  puts box
  print "\n"

  break unless prompt.yes?('Generate another character?')
end

puts 'May you walk on warm sands.'
