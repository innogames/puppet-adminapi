#
# Serveradmin query and group by hostname function
#
# Copyright (c) 2019 InnoGames GmbH
#

require 'puppet/util/errors'

require_relative './adminapi'

Puppet::Functions.create_function(:'adminapi::query_group_hostname') do

    dispatch :execute do
        param 'Hash[Adminapi::Attribute_id, Adminapi::Query_filter]', :filters
        param 'Array[Adminapi::Attribute_restrict]', :restrict
        return_type 'Hash[Adminapi::Hostname, Hash[Adminapi::Attribute_id, Adminapi::Attribute_value]]'
    end

    def execute(filters, restrict)
        Adminapi.query(filters, ['hostname'] + restrict, []).reduce({}) { |prev, cur|
            prev.update(cur['hostname'] => cur.reject { |k|
                k == 'hostname'
            })
        }
    end

    dispatch :execute_single do
        param 'Hash[Adminapi::Attribute_id, Adminapi::Query_filter]', :filters
        param 'Adminapi::Attribute_restrict', :restrict
        return_type 'Hash[Adminapi::Hostname, Adminapi::Attribute_value]'
    end

    def execute_single(filters, restrict)
        attribute = restrict.is_a?(Hash) ? restrict.keys[0] : restrict

        results = {}
        execute(filters, [restrict]).each { |key, val|
            results[key] = val[attribute]
        }
        results
    end
end
