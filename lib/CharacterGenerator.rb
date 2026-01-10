require_relative 'NameGenerator'
require_relative 'StatsGenerator'
require_relative 'ClassGenerator'
require_relative 'SkillsGenerator'

class Character
  attr_accessor :name, :race, :race_specials, :gender, :birthsign, :char_class, :attributes, :skills, :major_skills, :minor_skills,
                :other_skills

  def initialize(race_name, gender, name_db, stats_db, classes_db)
    @race = race_name
    @gender = gender.downcase
    # Generate Name
    @name = name_db.generate(@race, @gender)

    # Load Race Stats
    race_def = stats_db.get_race_def(@race)
    raise "Race data missing for #{@race}" unless race_def

    @race_specials = race_def['specials']

    # Apply Gender-Specific Attributes
    base_stats = race_def['stats'][@gender]
    @attributes = base_stats.dup

    # Pick a Birthsign
    @birthsign = stats_db.get_random_birthsign

    # Apply Birthsign Bonuses (if any) to Attributes
    if @birthsign['attribute_bonus']
      @birthsign['attribute_bonus'].each do |attr, value|
        @attributes[attr] += value if @attributes[attr]
      end
    end

    # select class
    @char_class = classes_db.get_random_class

    # add favored_atrribute boost
    favs = @char_class['favored_attributes']
    favs.each do |a|
      @attributes[a] += 10
    end

    @racial_skills = race_def['skill_bonuses']

    # skills

    sg = SkillsGenerator.new('../data/skills.yml', @char_class, @racial_skills)

    @skills = sg.skills
    @major_skills = sg.major
    @minor_skills = sg.minor
    @other_skills = sg.other
  end

  def to_s
    # RACIAL BONUSES
    # #{@racial_skills.map { |k, v| "+#{v} #{k.capitalize}" }.join("\n")}
    # ------------------------------------------
    <<~HEREDOC
      ====================================================================================
      IDENTITY
           Name:      #{@name}
           Race:      #{@gender.capitalize} #{@race.capitalize}
           Birthsign: #{@birthsign['name']}
           Class :    #{@char_class['name']}
      ------------------------------------------------------------------------------------
      ATTRIBUTES
           STR: #{@attributes['str']}  INT: #{@attributes['int']}
           WIL: #{@attributes['wil']}  AGI: #{@attributes['agi']}
           SPD: #{@attributes['spd']}  END: #{@attributes['end']}
           PER: #{@attributes['per']}  LUC: #{@attributes['luc']}
      ------------------------------------------------------------------------------------
      SKILLS
      Major:
           #{@major_skills.map { |k, v| "#{v} #{k.capitalize}" }.join("\n     ")}
      Minor:
           #{@minor_skills.map { |k, v| "#{v} #{k.capitalize}" }.join("\n     ")}
      Other:
           #{@other_skills.map { |k, v| "#{v} #{k.capitalize}" }.join("\n     ")}
      ====================================================================================
    HEREDOC
  end
end
