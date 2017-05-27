class Byakugan
  def initialize(auto_show_output: true)
    @target = {}
    @auto_show_output = auto_show_output
  end

  def register(klass)
    @target[klass] = {
      i_methods: klass.instance_methods(false),
      c_methods: klass.methods(false),
    }
    p @target
  end

  def watch!
    @tp = TracePoint.trace(:call) do |tp|
      check_instance_method(tp)
      check_class_method(tp)
    end

    if @auto_show_output
      at_exit &method(:output)
    end
  end

  def stop!
    @tp&.disable
  end

  private

  def check_instance_method(tp)
    target = @target[tp.defined_class]
    return if target.nil?
    target[:i_methods].delete(tp.method_id)
  end

  def check_class_method(tp)
    target = @target[tp.self]
    return if target.nil?
    target[:c_methods].delete(tp.method_id)
  end

  def output
    Formatter.new.output(@target)
  end

  class Formatter
    def output(target)
      puts '**** show unused methods ***'
      target.each do |klass, methods|
        methods[:i_methods].each do |m|
          puts "unused instance_method : #{klass}##{ m }"
        end
        methods[:c_methods].each do |m|
          puts "unused class method    : #{klass}.#{ m }"
        end
      end
    end
  end
end
