require 'yaml'

class StatsGenerator
  attr_reader :races, :birthsigns

  def initialize(file_path)
    data = YAML.load_file(file_path)
    @races = data['races']
    @birthsigns = data['birthsigns']
  end

  def get_race_def(race_key)
    @races[race_key.downcase]
  end

  def get_random_birthsign
    @birthsigns.sample
  end
end
