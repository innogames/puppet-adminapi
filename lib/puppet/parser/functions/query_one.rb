module Puppet::Parser::Functions
  newfunction(:query_one, :type => :rvalue) do |args|
    raise(Puppet::ParseError, "query_one(): Wrong number of arguments") if args.size != 2

    result = %x[adminapi_query -a #{args[1]} '#{args[0]}'].split(/\n/)

    raise(Puppet::ParseError, "query_one(): Couldn't get a single result") if result.size != 1

    return result[0]
  end
end
