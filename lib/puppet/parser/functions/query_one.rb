module Puppet::Parser::Functions
  newfunction(:query_one, :type => :rvalue) do |args|
    raise(Puppet::ParseError, "query_one(): Wrong number of arguments") if args.size != 2

    stdout = %x[adminapi_query -a #{args[1]} '#{args[0]}'].split(/\n/)

    raise(Puppet::ParseError, "query_one(): Couldn't get a single result") if stdout.size != 1

    if $? != 0
        raise(Puppet::Error, "adminapi_query command exit is %s expected 0" % $?)
    end

    return stdout[0]
  end
end
