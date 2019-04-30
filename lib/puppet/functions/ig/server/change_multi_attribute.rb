#
# Serveradmin multiadd function
#
# Copyright (c) 2018 InnoGames GmbH
#

require 'puppet/util/errors'

require_relative '../../../../ig/serveradmin'

Puppet::Functions.create_function(:'ig::server::change_multi_attribute') do

    dispatch :execute do
        param 'Integer', :object_id
        param 'Ig::Server::Attribute_id', :attribute
        param 'Array[Ig::Server::Attribute_value]', :additions
        param 'Array[Ig::Server::Attribute_value]', :removals
        return_type 'Undef'
    end

    def execute(object_id, attribute, additions, removals)
        if additions.none? and removals.none?
            return nil
        end

        Ig::Serveradmin.commit([], [{
            'object_id' => object_id,
            attribute   => {
                'action' => 'multi',
                'add'    => additions,
                'remove' => removals,
            },
        }], [])
    end
end
