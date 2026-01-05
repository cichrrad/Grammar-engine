require_relative '../lib/NameGenerator'

ng = NameGenerator.new('../lib/names.yml')

puts ng.generate('orc', 'female')
