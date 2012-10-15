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
    # We alias call to new so that crafted objects may nest themselves or other
    # crafted objects as transformations.
    alias call new

    # Define a method that extracts a collection of values from a parsed
    # document.
    #
    # name  - The Symbol name of the method.
    # paths - One or more String XPath of CSS queries. An optional Proc
    #         transformation on the extracted value may be appended.
    #
    # Returns an Array.
    def many(name, *paths)
      transform = extract_transformation paths

      define_method name do
        @node.search(*paths).map { |node| transform.call node }
      end
    end

    # Define a method that extracts a single value from a parsed document.
    #
    # name  - The Symbol name of the method.
    # paths - One or more String XPath of CSS queries. An optional Proc
    #         transformation on the extracted value may be appended.
    #
    # Returns an Object.
    def one(name, *paths)
      transform = extract_transformation paths

      define_method name do
        transform.call @node.at(*paths)
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

    private

    def extract_transformation(array)
      if array.last.respond_to? :call
        array.pop
      else
        Module.new do
          def self.call(node)
            node.text.strip if node
          end
        end
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
