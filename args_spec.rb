require 'rubygems'
gem 'rspec'
require 'rspec'
require 'args'

describe Args, "With no arguments" do
  before do
    @parser = Args.expect {}
  end

  it "should be valid" do
    @parser.should be_valid
  end

  it "should reject any unknown flags" do
    @parser.parse(%w(-f))
    @parser.should_not be_valid
  end
end

describe Args, "With one boolean argument" do
  before do
    @parser = Args.expect do
      boolean "f"
    end
  end

  it "should be false if no arguments" do
    @parser.parse(%w())
    @parser.should be_valid
    @parser["f"].should be(false)
  end

  it "should be true if present" do
    @parser.parse(%w(-f))
    @parser["f"].should be(true)
  end
end

describe Args, "With several boolean arguments" do
  before do
    @parser = Args.expect do
      boolean "f,g,h"
    end
  end

  it "should report f as false if not present among many arguments" do
    @parser.parse(%w(-g -h))
    @parser.should be_valid
    @parser["f"].should be(false)
  end

  it "should report f as true if present among others" do
    @parser.parse(%w(-g -f -h))
    @parser.should be_valid
    @parser["f"].should be(true)
  end

  it "should be invalid if unexpected arguments are present" do
    @parser.parse(%w(-q))
    @parser.should_not be_valid
  end
end

describe Args, "With one numeric argument" do
  before do
    @parser = Args.expect do
      number "n"
    end
  end

  it "should report n as zero if not present" do
    @parser.parse(%w())
    @parser.should be_valid
    @parser["n"].should == 0
  end

  it "should report n as number if present" do
    @parser.parse(%w(-n 23))
    @parser.should be_valid
    @parser["n"].should == 23
  end
end

describe Args, "With one string argument" do
  before do
    @parser = Args.expect do
      string "s"
    end
  end

  it "should report empty string if not present" do
    @parser.parse(%w())
    @parser.should be_valid
    @parser["s"].should == ""
  end

  it "should report the string if present" do
    @parser.parse(%w(-s bobby))
    @parser.should be_valid
    @parser["s"].should == "bobby"
  end
end

describe Args, "With a complex schema" do
  before do
    @args = Args.expect do
      boolean "f,g"
      number "n,m"
      string "s,d"
    end
  end

  it "Should have reasonable defaults for all" do
    @args.parse []
    @args.should be_valid
    @args["f"].should be(false)
    @args["g"].should be(false)
    @args["n"].should == 0
    @args["m"].should == 0
    @args["s"].should == ""
    @args["d"].should == ""
  end

  it "Should get all arguments" do
    @args.parse %w(-f -g -n 32 -m 48 -s bobby -d /home)
    @args.should be_valid
    @args["f"].should be(true)
    @args["g"].should be(true)
    @args["n"].should == 32
    @args["m"].should == 48
    @args["s"].should == "bobby"
    @args["d"].should == "/home"
  end

  it "should fail with an unexpected argument" do
    @args.parse %w(-q)
    @args.should_not be_valid
  end
end

describe Args, "With a single number-list element" do
  before do
    @parser = Args.expect do
      number_list "l"
    end
  end

  it "should report empty list if no argument" do
    @parser.parse []
    @parser.should be_valid
    @parser["l"].should be_empty
  end

  it "should assign list of numbers from argument" do
    @parser.parse %w(-l 1,2,3,4)
    @parser.should be_valid
    @parser["l"].should == [1, 2, 3, 4]
  end
end



