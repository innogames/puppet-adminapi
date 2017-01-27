module Puppet::Parser::Functions
  newfunction(:serveradmin_set, :type => :rvalue) do |args|
    raise(Puppet::ParseError, "serveradmin_set(): Wrong number of arguments") if args.size != 3

    stdout = %x[adminapi_update #{args[0]} #{args[1]}='#{args[2]}']

    if $? != 0
        raise(Puppet::Error, "adminapi_query command exit is %s expected 0" % $?)
    end

    return stdout
  end
end
