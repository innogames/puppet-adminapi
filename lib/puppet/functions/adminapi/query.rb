#
# Serveradmin query function
#
# Copyright (c) 2019 InnoGames GmbH
#

require 'puppet/util/errors'

require_relative './adminapi'

Puppet::Functions.create_function(:'adminapi::query') do

    dispatch :execute do
        param 'Hash[Adminapi::Attribute_id, Adminapi::Query_filter]', :filters
        param 'Array[Adminapi::Attribute_restrict]', :restrict
        optional_param 'Array[Adminapi::Attribute_id]', :order_by
        return_type 'Array[Hash[Adminapi::Attribute_id, Adminapi::Attribute_value]]'
    end

    def execute(filters, restrict, order_by=[])
        Adminapi.query(filters, restrict, order_by)
    end

    dispatch :execute_single do
        param 'Hash[Adminapi::Attribute_id, Adminapi::Query_filter]', :filters
        optional_param 'Adminapi::Attribute_restrict', :restrict
        optional_param 'Array[Adminapi::Attribute_id]', :order_by
        return_type 'Array[Adminapi::Attribute_value]'
    end

    def execute_single(filters, restrict='hostname', order_by=[])
        attribute = restrict.is_a?(Hash) ? restrict.keys[0] : restrict

        execute(filters, [restrict], order_by).map { |cur|
            cur[attribute]
        }
    end
end
