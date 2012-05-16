#An argument parser.  You use it like this:
#
#def main()
#  parser = Args.expect do
#    boolean "l,v"
#    number "p"
#    string "d"
#  end
#
#  parser.parse(ARGV)
#  logging = parser["l"]
#  verbose = parser["v"]
#  port = parser["p"]
#  directory = parser["d"]
#
#  #...
#end

class Args
  def self.expect &proc
    parser = Parser.new
    parser.instance_eval(&proc)
    parser
  end

  class Parser
    def initialize
      @bools = {}
      @nums = {}
      @strings = {}
      @unex = []
      @valid = true;
    end

    def valid?
      @valid
    end

    #---------------------------------------------
    # The argument flags: boolean, number, string
    #---------------------------------------------

    def boolean(args)
      args.split(",").each do |arg|
        @bools[arg] = false;
      end
    end

    def number(args)
      args.split(",").each do |arg|
        @nums[arg] = 0
      end
    end

    def string(args)
      args.split(",").each do |arg|
        @strings[arg] = ""
      end
    end

    #
    # Parse the command line
    #
    
    def parse(args)
      i = 0;

      while i < args.length do
        arg = args[i]
        i += 1
        if arg[0, 1] == '-'
          name = arg[1..-1]
          if @bools.has_key?(name)
            @bools[name] = true
          elsif @nums.has_key?(name)
            @nums[name] = args[i].to_f
            i += 1
          elsif @strings.has_key?(name)
            @strings[name] = args[i].dup
            i += 1
          else
            @unex << name
            @valid = false
          end
        end
      end

      def [](arg)
        return @bools[arg] if @bools.has_key? arg
        return @nums[arg] if @nums.has_key? arg
        return @strings[arg] if @strings.has_key? arg
      end
    end
  end
end

