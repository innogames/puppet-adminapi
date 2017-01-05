module Puppet::Parser::Functions
  newfunction(:serveradmin_set, :type => :rvalue) do |args|
    raise(Puppet::ParseError, "serveradmin_set(): Wrong number of arguments") if args.size != 3

    %x[adminapi_update #{args[0]} #{args[1]}='#{args[2]}']

    raise(Puppet::ParseError, "serveradmin_set(): failed") unless $? == 0
  end
end
