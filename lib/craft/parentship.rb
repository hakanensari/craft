class Craft
  class Parentship
    def initialize(child, parent)
      @child, @parent = child, parent
    end

    def restore
      create unless exists?
      @child.instance_variable_set "@#{@parent.name}", @parent
    end

    def create
      (class << @child; self; end).class_eval "attr :#{@parent.name}"
    end

    def exists?
      @child.respond_to? @parent.name
    end
  end
end
