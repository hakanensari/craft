require_relative 'helper'

class Craft
  describe Association do
    let(:parent) { Class.new { def name; 'foo'; end }.new }
    let(:child) { Class.new.new }

    describe '.build' do
      it 'builds the association' do
        Association.build parent, child
        child.foo.must_equal parent
      end

      it 'does not override existing attribute' do
        child.instance_eval 'def foo; "ok"; end'
        Association.build parent, child
        child.foo.must_equal 'ok'
      end
    end
  end
end
