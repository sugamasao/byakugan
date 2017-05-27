require 'byakugan'

class ByakuganTest < Test::Unit::TestCase
  module Foo
    class Bar
      def m1
        p :hi
      end

      def m2
        p :hey
      end

      def self.m3
      end

      class << self
        def m4
        end
      end
    end
  end

  def test_watch_method
    b = Byakugan.new(auto_show_output: false)
    b.register(Foo::Bar)
    b.watch!
    # call m1
    Foo::Bar.new.m1
    # call m3
    Foo::Bar.m4
    b.stop!
    
    ret = b.instance_variable_get(:@target)
    assert(ret[Foo::Bar].i_methods.size == 1)
    assert(ret[Foo::Bar].i_methods.first == :m2)
    assert(ret[Foo::Bar].c_methods.size == 1)
    assert(ret[Foo::Bar].c_methods.first == :m3)
  end
end
