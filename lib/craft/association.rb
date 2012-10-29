class Craft
  class Association
    def self.build(parent, child)
      new(parent, child).build
    end

    def initialize(parent, child)
      @parent, @child = parent, child
    end

    def build
      define_attribute unless attribute_defined?
      set_value
    end

    private

    def attribute_defined?
      @child.respond_to? parent_name
    end

    def define_attribute
      (class << @child; self; end).class_eval "attr :#{parent_name}"
    end

    def parent_name
      @parent_name ||= @parent.class.name
        .gsub(/.*::/, '')
        .gsub(/([a-z0-9])([A-Z])/,'\1_\2')
        .downcase
    end

    def set_value
      @child.instance_variable_set "@#{parent_name}", @parent
    end
  end
end
