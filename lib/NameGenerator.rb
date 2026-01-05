require 'yaml'

class NameGenerator
  def initialize(data_file)
    @data = YAML.load_file(data_file)
  end

  def generate(race_name, gender)
    # Normalize inputs
    race_key = race_name.downcase
    gender_key = gender.downcase

    race_data = @data[race_key]
    raise "Race '#{race_name}' not found in database." unless race_data

    # pick random name for my class and sex
    first_name = get_first_name(race_data, race_key, gender_key)
    # (if applicable)
    surname = get_surname(race_data, race_key, gender_key)
    surname ? "#{first_name} #{surname}" : first_name
  end

  private

  def get_first_name(race_data, race_key, gender_key)
    if race_key == 'argonian'
      # 50% chance to use a static name from the name list
      # 50% chance to generate a dynamic phrase
      if rand < 0.5
        generate_dynamic_argonian_name(race_data['phrase_parts'], gender_key)
      else
        naming_convention = %w[jel_names imperial_names].sample
        race_data[gender_key][naming_convention].sample
      end
    else
      # Standard logic for other races
      race_data[gender_key]['first_names'].sample
    end
  end

  def generate_dynamic_argonian_name(parts, gender)
    patterns = [
      :verb_preposition_noun, # "Walks-In-Shadows"
      :verb_pronoun_noun,     # "Hides-His-Foot"
      :adjective_noun,        # "Big-Head"
      :noun_noun              # "Snail-Tail"
    ]

    template = patterns.sample

    # pronoun match
    pronoun = gender == 'male' ? 'His' : 'Her'

    name_components = case template
                      when :verb_preposition_noun
                        # "Walks-In-Shadows"
                        [parts['verbs'].sample, parts['prepositions'].sample, parts['nouns'].sample]

                      when :verb_pronoun_noun
                        # "Hides-His-Foot"
                        [parts['verbs'].sample, pronoun, parts['nouns'].sample]

                      when :adjective_noun
                        # "Big-Head"
                        [parts['adjectives'].sample, parts['nouns'].sample]

                      when :noun_noun
                        # "Snail-Tail"
                        [parts['nouns'].sample, parts['nouns'].sample]
                      end

    name_components.join('-')
  end

  def get_surname(race_data, race_key, gender_key)
    # Check if race has surname data at all
    return nil if race_data['surnames'].nil? && race_data['surname_data'].nil?
    return nil if race_data['surnames'] && race_data['surnames'].empty?

    case race_key
    when 'orc'
      # match gender
      root = race_data['surnames'].sample
      prefix = gender_key == 'male' ? 'gro-' : 'gra-'
      "#{prefix}#{root}"

    when 'imperial'
      # choose unisex / gendered
      type = %w[roots unisex].sample

      if type == 'unisex'
        race_data['surname_data']['unisex'].sample
      else
        root = race_data['surname_data']['roots'].sample
        # append roman-like vibes
        suffix = gender_key == 'male' ? 'us' : 'a'
        "#{root}#{suffix}"
      end

    else
      # Standard surname (Dunmer, Breton, Ashlander)
      race_data['surnames'].sample
    end
  end
end
