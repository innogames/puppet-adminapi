#
# Serveradmin query one object function
#
# Copyright (c) 2019 InnoGames GmbH
#

require 'puppet/util/errors'

require_relative './adminapi'

Puppet::Functions.create_function(:'adminapi::query_one') do

    dispatch :execute do
        param 'Hash[Adminapi::Attribute_id, Adminapi::Query_filter]', :filters
        param 'Array[Adminapi::Attribute_restrict]', :restrict
        return_type 'Hash[Adminapi::Attribute_id, Adminapi::Attribute_value]'
    end

    def execute(filters, restrict)
        results = Adminapi.query(filters, restrict, [])
        if results.length == 0
            fail("Query returned no objects from Serveradmin! Filters: #{filters.inspect}")
        elsif results.length > 1
            fail("Query returned multiple objects from Serveradmin! Filters: #{filters.inspect}")
        else
            results[0]
        end
    end

    dispatch :execute_single do
        param 'Hash[Adminapi::Attribute_id, Adminapi::Query_filter]', :filters
        optional_param 'Adminapi::Attribute_restrict', :restrict
        return_type 'Adminapi::Attribute_value'
    end

    def execute_single(filters, restrict='hostname')
        attribute = restrict.is_a?(Hash) ? restrict.keys[0] : restrict

        execute(filters, [restrict])[attribute]
    end

    dispatch :execute_hostname do
        param 'Adminapi::Hostname', :hostname
        param 'Array[Adminapi::Attribute_restrict]', :restrict
        return_type 'Hash[Adminapi::Attribute_id, Adminapi::Attribute_value]'
    end

    def execute_hostname(hostname, restrict)
        execute({'hostname' => hostname}, restrict)
    end

    dispatch :execute_single_hostname do
        param 'Adminapi::Hostname', :hostname
        optional_param 'Adminapi::Attribute_restrict', :restrict
        return_type 'Adminapi::Attribute_value'
    end

    def execute_single_hostname(hostname, restrict='hostname')
        execute_single({'hostname' => hostname}, restrict)
    end
end
