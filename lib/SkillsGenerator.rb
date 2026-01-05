require 'yaml'

class SkillsGenerator
  attr_reader :skills_yml, :skills, :major, :minor, :other

  def initialize(file_path, klass, racial_skills)
    data = YAML.load_file(file_path)
    @skills_yml = data['skills']
    @major = {}
    @minor = {}
    @other = {}
    specs = []
    # everything starts at 5
    @skills = {}
    @skills_yml.each do |i|
      specs = i['skills'] if i['specialization'] == klass['specialization']
      i['skills'].each do |j|
        @skills[j.downcase] = 5
      end
    end

    # class minor skills start at 15
    # major at 30
    # specialized get + 5
    # + amount from racial bonus
    minors = klass['minor_skills']
    minors.each do |s|
      @skills[s] = 15
    end

    majors = klass['major_skills']
    majors.each do |s|
      @skills[s] = 30
    end

    specs.each do |s|
      @skills[s.downcase] += 5
    end

    racial_skills.each do |k, v|
      @skills[k.downcase] += v
    end

    @skills.each do |k, v|
      if majors.include?(k.downcase)
        @major[k.downcase] = v
      elsif minors.include?(k.downcase)
        @minor[k.downcase] = v
      else
        @other[k.downcase] = v
      end
    end

  end
end
