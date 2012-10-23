require 'craft/version'
require 'nokogiri'

# Craft objects out of HTML and XML.
#
# Examples
#
#   module Transformations
#     IntegerTransform = lambda { |n| Integer n.text }
#   end
#
#   class Person < Craft
#     include Transformations
#
#     one :name, 'div.name'
#     one :age, 'div.age', IntegerTransform
#     many :friends, 'li.friend', Person
#   end
#
class Craft
  class << self
    # Returns the Array names of the attibutes.
    attr :attribute_names

    # Define an attribute that extracts a collection of values from a parsed
    # document.
    #
    # name  - The Symbol name of the attribute.
    # paths - One or more String XPath of CSS queries. An optional Proc
    #         transformation on the extracted value may be appended. If none is
    #         appended, the default transformation returns the stripped String
    #         value of the node.
    #
    # Returns nothing.
    def many(name, *paths)
      transform = pop_transform_from_paths paths
      @attribute_names << name

      define_method name do
        @node.search(*paths).map { |node| instance_exec node, &transform }
      end
    end

    # Define an attribute that extracts a single value from a parsed document.
    #
    # name  - The Symbol name of the attribute.
    # paths - One or more String XPath of CSS queries. An optional Proc
    #         transformation on the extracted value may be appended. If none is
    #         appended, the default transformation returns the stripped String
    #         value of the node.
    #
    # Returns nothing.
    def one(name, *paths)
      transform = pop_transform_from_paths paths
      @attribute_names << name

      define_method name do
        instance_exec @node.at(*paths), &transform
      end
    end

    # Parse a document.
    #
    # body - A String HTML or XML document.
    #
    # Returns an instance of its self.
    def parse(body)
      new Nokogiri body
    end

    # Define an attribute that returns a value without parsing the document.
    #
    # name  - The Symbol name of the attribute.
    # value - Some value the attribute should return. If given a Proc, the
    #         value will be generated dynamically (default: nil).
    #
    # Returns nothing.
    def stub(name, value = nil)
      @attribute_names << name

      define_method name do
        value.respond_to?(:call) ? value.call : value
      end
    end

    def to_proc
      klass = self
      ->(node) { klass.new node }
    end

    private

    def inherited(subclass)
      subclass.instance_variable_set :@attribute_names, []
    end

    def pop_transform_from_paths(array)
      if array.last.respond_to? :to_proc
        array.pop
      else
        ->(node) { node.text.strip if node }
      end
    end
  end

  # Craft a new object.
  #
  # node - A Nokogiri::XML::Node.
  def initialize(node)
    @node = node
  end
end
