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
    # Define a method that extracts a collection of values from a parsed
    # document.
    #
    # name  - The Symbol name of the method.
    # paths - One or more String XPath of CSS queries. An optional Proc
    #         transformation on the extracted value may be appended. If none is
    #         appended, the default transformation returns the stripped String
    #         value of the node.
    #
    # Returns an Array.
    def many(name, *paths)
      transform = pop_transform_from_paths paths

      define_method name do
        @node.search(*paths).map { |node| instance_exec node, &transform }
      end
    end

    # Define a method that extracts a single value from a parsed document.
    #
    # name  - The Symbol name of the method.
    # paths - One or more String XPath of CSS queries. An optional Proc
    #         transformation on the extracted value may be appended. If none is
    #         appended, the default transformation returns the stripped String
    #         value of the node.
    #
    # Returns an Object.
    def one(name, *paths)
      transform = pop_transform_from_paths paths

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

    def to_proc
      ->(klass, node) { klass.new node }.curry.(self)
    end

    private

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
