require 'args.rb'

def main()
  parser = Args.expect do
    boolean "l"
    number "p"
    string "d"
  end

  parser.parse(ARGV)

  logging = parser["l"]
  port = parser["p"]
  directory = parser["d"]

  puts "Logging=#{logging}, port=#{port}, dir=#{directory}"
  #...
end

main