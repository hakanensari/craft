require 'craft/association'
require 'craft/version'
require 'nokogiri'

# Craft objects out of HTML and XML.
#
# Examples
#
#   module Transformations
#     IntegerTransform = lambda { |n| Integer n.text }
#     Timestamp        = lambda { Time.now }
#   end
#
#   class Person < Craft
#     include Transformations
#
#     one :name, 'div.name'
#     one :age, 'div.age', IntegerTransform
#     many :friends, 'li.friend', Person
#     stub :created_at, Timestamp
#   end
#
class Craft
  class << self
    # Returns an Array of names for the attributes defined in the class.
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
    # Returns an instance of self, or, should we say, itself.
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
        value.respond_to?(:call) ? instance_exec(&value) : value
      end
    end

    # Casts self to a Proc transform.
    def to_proc
      klass = self
      ->(node) { klass.new node, self }
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
  # node   - A Nokogiri::XML::Node.
  # parent - A Craft object (default: nil).
  def initialize(node, parent = nil)
    @node = node
    Association.build(parent, self) if parent
  end

  # Returns the Hash attributes.
  def attributes
    Hash[attribute_names.map { |key| [key, self.send(key)] }]
  end

  # Returns an Array of names for the attributes on the object.
  def attribute_names
    self.class.attribute_names
  end

  # Returns a String name for the object.
  def name
    self.class.name
      .gsub(/([a-z0-9])([A-Z])/,'\1_\2')
      .downcase
  end
end
