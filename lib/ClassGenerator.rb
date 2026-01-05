require 'yaml'

class ClassGenerator
  attr_reader :classes, :custom

  def initialize(file_path, do_custom: false)
    data = YAML.load_file(file_path)
    @classes = data['classes']
    @custom = do_custom
  end

  def get_random_class
    @classes.sample
  end
end
