require 'bundler/setup'
require 'minitest/autorun'
require 'craft'

describe Craft do
  let(:html) { '<html><ul><li>1</li><li>2</li>' }
  let(:klass) { Class.new Craft }
  let(:instance) { klass.parse html }

  describe '.attribute_names' do
    it 'is empty by default' do
      klass.attribute_names.must_equal []
    end

    it 'does not reference other attribute names' do
      klass.stub :foo
      other = Class.new(Craft) { stub :bar }
      klass.attribute_names.wont_equal other.attribute_names
    end
  end

  describe '.many' do
    it 'extracts nodes' do
      klass.many :foo, 'li'
      instance.foo.must_equal %w(1 2)
    end

    it 'transforms' do
      klass.many :foo, 'li', ->(node) { node.text.to_i }
      instance.foo.must_equal [1, 2]
    end

    it 'transforms in scope' do
      klass.many :foo, 'li', ->(node) { bar }
      klass.send(:define_method, :bar) { 'bar' }
      instance.foo.must_equal ['bar', 'bar']
    end

    it 'stores attribute name' do
      klass.many :foo, 'li'
      klass.attribute_names.must_include :foo
    end

    it 'nests' do
      klass.many :foo, 'ul', Class.new(Craft)
      instance.foo.each { |attr| attr.must_be_kind_of Craft }
    end
  end

  describe '.one' do
    it 'extracts a node' do
      klass.one :foo, 'li'
      instance.foo.must_equal '1'
    end

    it 'transforms' do
      klass.one :foo, 'li', ->(node) { node.text.to_i }
      instance.foo.must_equal 1
    end

    it 'transforms in scope' do
      klass.one :foo, 'li', ->(node) { bar }
      klass.send(:define_method, :bar) { 'bar' }
      instance.foo.must_equal 'bar'
    end

    it 'stores attribute name' do
      klass.one :foo, 'li'
      klass.attribute_names.must_include :foo
    end

    it 'nests' do
      klass.one :foo, 'ul', Class.new(Craft)
      instance.foo.must_be_kind_of Craft
    end

    describe 'given no matches' do
      before { klass.one :foo, 'bar' }

      it 'returns nil' do
        instance.foo.must_be_nil
      end
    end
  end

  describe '.stub' do
    it 'returns nil by default' do
      klass.stub :foo
      instance.foo.must_be_nil
    end

    it 'returns a static value' do
      klass.stub :foo, 1
      instance.foo.must_equal 1
    end

    it 'returns a dynamic value' do
      klass.stub :foo, -> { Time.now }
      instance.foo.must_be_instance_of Time
    end

    it 'transforms in scope' do
      klass.stub :foo, -> { bar }
      klass.send(:define_method, :bar) { 'bar' }
      instance.foo.must_equal 'bar'
    end

    it 'stores attribute name' do
      klass.stub :foo
      klass.attribute_names.must_include :foo
    end
  end

  describe '#attributes' do
    it 'returns attributes' do
      klass.stub :foo
      klass.one  :bar, 'li'
      instance.attributes.must_equal({ foo: nil, bar: '1' })
    end
  end
end
