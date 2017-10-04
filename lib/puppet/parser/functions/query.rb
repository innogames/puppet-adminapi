#
# Query an attribute from Serveradmin
#
# XXX This is deprecated.  Use ig::server::query instead.
#
# Copyright (c) 2017, InnoGames GmbH
#

module Puppet::Parser::Functions
  newfunction(:query, :type => :rvalue) do |args|
    raise(Puppet::ParseError, "query(): Wrong number of arguments") if args.size != 2

    output = %x[adminapi_query -a #{args[1]} -o #{args[1]} '#{args[0]}' 2>&1].split(/\n/)

    if $? != 0
        raise(Puppet::Error, "query(): #{output[-1]}")
    end

    return output
  end
end
