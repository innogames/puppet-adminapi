#
# Implementation of ig::server functions
#
# Copyright (c) 2017, InnoGames GmbH
#

module Puppet::Parser::Functions
  newfunction(:igserver, :type => :rvalue) do |args|
    raise(Puppet::ParseError, "igserver(): Wrong number of arguments") if args.size != 1

    output = %x[igserver #{args[0]} 2>&1].split(/\n/)

    if $? != 0
        raise(Puppet::Error, "igserver(): command failed: 'igserver #{args[0]}': #{output[-1]}")
    end

    return output
  end
end
