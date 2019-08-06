#
# Serveradmin query and group by an attribute function
#
# Copyright (c) 2019 InnoGames GmbH
#

require 'puppet/util/errors'

require_relative './adminapi'

Puppet::Functions.create_function(:'adminapi::query_group') do

    dispatch :execute do
        param 'Hash[Adminapi::Attribute_id, Adminapi::Query_filter]', :filters
        param 'Adminapi::Attribute_id', :group_by
        param 'Array[Adminapi::Attribute_restrict]', :restrict
        optional_param 'Array[Adminapi::Attribute_id]', :order_by
        return_type 'Hash[Adminapi::Attribute_value, Array[Hash[Adminapi::Attribute_id, Adminapi::Attribute_value], 1]]'
    end

    def execute(filters, group_by, restrict, order_by=[])
        results = {}
        Adminapi.query(filters, [group_by] + restrict, order_by).each { |cur|
            key = cur[group_by]

            unless results.key?(key)
                results[key] = []
            end

            results[key].push(cur.reject { |k|
                k == group_by
            })
        }
        results
    end

    dispatch :execute_single do
        param 'Hash[Adminapi::Attribute_id, Adminapi::Query_filter]', :filters
        param 'Adminapi::Attribute_id', :group_by
        optional_param 'Adminapi::Attribute_restrict', :restrict
        optional_param 'Array[Adminapi::Attribute_id]', :order_by
        return_type 'Hash[Adminapi::Attribute_value, Array[Adminapi::Attribute_value, 1]]'
    end

    def execute_single(filters, group_by, restrict='hostname', order_by=[])
        attribute = restrict.is_a?(Hash) ? restrict.keys[0] : restrict

        results = {}
        execute(filters, group_by, [restrict], order_by).each { |key, val|
            results[key] = val.map { |cur|
                cur[attribute]
            }
        }
        results
    end
end
