module Puppet::Parser::Functions
  newfunction(:query, :type => :rvalue) do |args|
    raise(Puppet::ParseError, "query(): Wrong number of arguments") if args.size != 2

    return %x[adminapi_query -a #{args[1]} -o #{args[1]} '#{args[0]}'].split(/\n/)
  end
end
