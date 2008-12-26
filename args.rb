class Args
  def self.expect &proc
    parser = Parser.new
    parser.instance_eval(&proc)
    parser
  end

  class Parser
    def initialize
      @args = {}
      @valid = true;
    end

    def valid?
      @valid
    end

    def [](name)
      @args[name].value
    end

    def parse(arguments)
      parse_argument(arguments) until arguments.empty?
    end

    private

    def parse_argument(arguments)
      argument = arguments.shift
      if is_flag?(argument)
        name = get_argument_name(argument)
        set_argument_value(name, arguments)
      end
    end

    def is_flag?(argument)
      argument[0, 1] == '-'
    end
    
    def set_argument_value(name, arguments)
      if @args.has_key?(name)
        @args[name].set_value(arguments)
      else
        @valid = false
      end
    end

    def get_argument_name(argument)
      argument[1..-1]
    end

    def declare_arguments(args, marshaler)
      args.split(",").each {|name| @args[name] = marshaler.new}
    end

    def self.add_declarator(name, marshaler)
      method_text = "def #{name}(args) declare_arguments(args, #{marshaler}) end"
      Parser.module_eval(method_text)
    end
  end  #Parser

  class BoolMarshaler
    Parser.add_declarator("boolean", self.name)
    attr_accessor :value

    def initialize
      @value = false;
    end

    def set_value(arguments)
      @value = true
    end
  end

  class NumberMarshaler
    Parser.add_declarator("number", self.name)
    attr_accessor :value

    def initialize
      @value = 0
    end

    def set_value(arguments)
      @value = arguments.shift.to_f
    end
  end

  class StringMarshaler
    Parser.add_declarator("string", self.name)
    attr_accessor :value

    def initialize
      @value = ""
    end

    def set_value(arguments)
      @value = arguments.shift.dup
    end
  end

  class NumberListMarshaler
    Parser.add_declarator("number_list", self.name)
    attr_accessor :value

    def initialize
      @value = []
    end

    def set_value(arguments)
      string_list = arguments.shift
      string_list.split(",").each {|string|
        @value << string.to_f
      }
    end
  end
end #Args
