#
# Call adminapi executable
#
# Copyright (c) 2018, InnoGames GmbH
#

module Puppet::Parser::Functions
    newfunction(:adminapi, :type => :rvalue) do |args|
        raise(Puppet::ParseError, "adminapi(): Wrong number of arguments") if args.size != 1

        output = %x[adminapi #{args[0]} 2>&1].split(/\n/)

        if $? != 0
            raise(Puppet::Error, "adminapi(): command failed: 'adminapi #{args[0]}': #{output[-1]}")
        end

        return output
    end
end
