require_relative '../lib/NameGenerator'
require_relative '../lib/StatsGenerator'

class Character
  attr_accessor :name, :race, :gender, :birthsign, :attributes, :major_skills, :minor_skills

  def initialize(race_name, gender, name_db, lore_db)
    @race = race_name
    @gender = gender.downcase

    # Generate Name
    @name = name_db.generate(@race, @gender)

    # Load Race Stats
    race_def = lore_db.get_race_def(@race)
    raise "Race data missing for #{@race}" unless race_def

    # Apply Gender-Specific Attributes
    base_stats = race_def['stats'][@gender]
    @attributes = base_stats.dup

    # Pick a Birthsign
    @birthsign = lore_db.get_random_birthsign

    # Apply Birthsign Bonuses (if any) to Attributes
    if @birthsign['attribute_bonus']
      @birthsign['attribute_bonus'].each do |attr, value|
        # keys in YAML are strings, convert to symbols if needed or stick to strings
        @attributes[attr] += value if @attributes[attr]
      end
    end

    # Skill Generation
    # TODO
    @racial_skills = race_def['skill_bonuses']
  end

  def to_s
    <<~HEREDOC
      ==========================================
      IDENTITY
      Name:      #{@name}
      Race:      #{@gender.capitalize} #{@race.capitalize}
      Birthsign: #{@birthsign['name']}
      ------------------------------------------
      ATTRIBUTES (Base + Sign)
      STR: #{@attributes['str']}  INT: #{@attributes['int']}
      WIL: #{@attributes['wil']}  AGI: #{@attributes['agi']}
      SPD: #{@attributes['spd']}  END: #{@attributes['end']}
      PER: #{@attributes['per']}  LUC: #{@attributes['luc']}
      ------------------------------------------
      RACIAL BONUSES
      #{@racial_skills.map { |k, v| "+#{v} #{k.capitalize}" }.join("\n")}
      ==========================================
    HEREDOC
  end
end

# DEMO
ld = StatsGenerator.new('../data/stats.yml')
nd = NameGenerator.new('../data/names.yml')
C = Character.new('Orc', 'male', nd, ld)

puts C
