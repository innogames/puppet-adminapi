#
# Serveradmin multiadd function
#
# Copyright (c) 2019 InnoGames GmbH
#

require 'puppet/util/errors'

require_relative './adminapi'

Puppet::Functions.create_function(:'adminapi::change_multi_attribute') do

    dispatch :execute do
        param 'Integer', :object_id
        param 'Adminapi::Attribute_id', :attribute
        param 'Array[Adminapi::Attribute_value]', :additions
        param 'Array[Adminapi::Attribute_value]', :removals
        optional_param 'Boolean', :no_fail
        return_type 'Undef'
    end

    def execute(object_id, attribute, additions, removals, no_fail = false)
        if additions.none? and removals.none?
            return nil
        end

        Adminapi.commit([], [{
            'object_id' => object_id,
            attribute   => {
                'action' => 'multi',
                'add'    => additions,
                'remove' => removals,
            },
        }], [], no_fail)
    end
end
