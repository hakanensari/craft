require_relative 'helper'

class Craft
  describe Association do
    let(:parent) { Class.new { def name; 'foo'; end }.new }
    let(:child) { Class.new.new }

    describe '.build' do
      it 'builds the association' do
        parent.class.stub! :name, 'Foo' do
          Association.build parent, child
          child.foo.must_equal parent
        end
      end

      it 'does not override an existing attribute' do
        parent.class.stub! :name, 'Foo' do
          child.instance_eval 'def foo; "ok"; end'
          Association.build parent, child
          child.foo.must_equal 'ok'
        end
      end

      it 'underscores the attribute name' do
        parent.class.stub! :name, 'FooBar' do
          Association.build parent, child
          child.must_respond_to :foo_bar
        end
      end

      it 'ignores namespaces' do
        parent.class.stub! :name, 'Foo::Bar::Baz' do
          Association.build parent, child
          child.must_respond_to :baz
        end
      end
    end
  end
end
