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

    stdout = %x[adminapi_query -a #{args[1]} -o #{args[1]} '#{args[0]}'].split(/\n/)

    if $? != 0
        raise(Puppet::Error, "adminapi_query command exit is %s expected 0" % $?)
    end

    return stdout
  end
end
