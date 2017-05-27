require_relative 'byakugan'

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

b = Byakugan.new
b.register(Foo::Bar)
b.watch!

# call m1
Foo::Bar.new.m1
# call m3
Foo::Bar.m4
