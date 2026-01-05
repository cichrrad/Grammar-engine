require 'yaml'

class StatsGenerator
  attr_reader :races, :birthsigns

  def initialize(race_file_path, birthsigns_file_path)
    data_r = YAML.load_file(race_file_path)
    data_b = YAML.load_file(birthsigns_file_path)
    @races = data_r['races']
    @birthsigns = data_b['birthsigns']
  end

  def get_race_def(race_key)
    @races[race_key.downcase]
  end

  def get_random_birthsign
    @birthsigns.sample
  end
end
