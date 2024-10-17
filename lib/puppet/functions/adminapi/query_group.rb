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
        optional_param 'Boolean', :split_list_elements
        return_type 'Hash[Adminapi::Attribute_value, Array[Hash[Adminapi::Attribute_id, Adminapi::Attribute_value], 1]]'
    end

    def execute(filters, group_by, restrict, order_by=[], split_list_elements=false)
        results = {}
        Adminapi.query(filters, [group_by] + restrict, order_by).each { |cur|
            key = cur[group_by]

            # check if it is nil or not
            if split_list_elements and not key.nil? and key.is_a?(Array)
                # Key is an array, so we need to split it
                key.each { |k|
                    unless results.key?(k)
                        results[k] = []
                    end
                    results[k].push(cur.reject { |k|
                        k == group_by
                    })
                }
            else
                unless results.key?(key)
                    results[key] = []
                end
                results[key].push(cur.reject { |k|
                    k == group_by
                })
            end
        }
        results
    end

    dispatch :execute_single do
        param 'Hash[Adminapi::Attribute_id, Adminapi::Query_filter]', :filters
        param 'Adminapi::Attribute_id', :group_by
        optional_param 'Adminapi::Attribute_restrict', :restrict
        optional_param 'Array[Adminapi::Attribute_id]', :order_by
        optional_param 'Boolean', :split_list_elements
        return_type 'Hash[Adminapi::Attribute_value, Array[Adminapi::Attribute_value, 1]]'
    end

    def execute_single(filters, group_by, restrict='hostname', order_by=[], split_list_elements=false)
        attribute = restrict.is_a?(Hash) ? restrict.keys[0] : restrict

        results = {}
        execute(filters, group_by, [restrict], order_by, split_list_elements).each { |key, val|
            if split_list_elements and not key.nil? and key.is_a?(Array)
                key.each { |k|
                    results[k] = val.map {
                        |cur| cur[attribute]
                    }
                }
            else
                results[key] = val.map {
                    |cur| cur[attribute]
                }
            end
        }
        results
    end
end
