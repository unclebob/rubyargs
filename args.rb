class Args
  def self.expect &proc
    parser = Parser.new
    parser.instance_eval(&proc)
    parser
  end

  class Parser
    def initialize
      @bool_args = {}
      @number_args = {}
      @string_args = {}
      @unexpected_args = []
      @valid = true;
    end

    def valid?
      @valid
    end

    def boolean(args)
      args.split(",").each do |name|
        @bool_args[name] = false;
      end
    end

    def number(args)
      args.split(",").each do |name|
        @number_args[name] = 0
      end
    end

    def string(args)
      args.split(",").each do |name|
        @string_args[name] = ""
      end
    end

    def parse(arguments)
      index = 0;

      while index < arguments.length do
        argument = arguments[index]
        index += 1
        if argument[0, 1] == '-'
          name = argument[1..-1]
          if @bool_args.has_key?(name)
            @bool_args[name] = true
          elsif @number_args.has_key?(name)
            @number_args[name] = arguments[index].to_f
            index += 1
          elsif @string_args.has_key?(name)
            @string_args[name] = arguments[index].dup
            index += 1
          else
            @unexpected_args << name
            @valid = false
          end
        end
      end

      def [](name)
        return @bool_args[name] if @bool_args.has_key? name
        return @number_args[name] if @number_args.has_key? name
        return @string_args[name] if @string_args.has_key? name
      end
    end
  end
end

