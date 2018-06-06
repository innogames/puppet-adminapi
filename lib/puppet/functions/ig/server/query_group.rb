#
# Serveradmin query and group by an attribute function
#
# Copyright (c) 2018 InnoGames GmbH
#

require 'puppet/util/errors'

require_relative '../../../../ig/serveradmin'

Puppet::Functions.create_function(:'ig::server::query_group') do

    dispatch :execute do
        param 'Hash[Ig::Server::Attribute_id, Ig::Server::Query_filter]', :filters
        param 'Ig::Server::Attribute_id', :group_by
        param 'Array[Ig::Server::Attribute_restrict]', :restrict
        optional_param 'Array[Ig::Server::Attribute_id]', :order_by
        return_type 'Hash[Ig::Server::Attribute_value, Array[Hash[Ig::Server::Attribute_id, Ig::Server::Attribute_value], 1]]'
    end

    def execute(filters, group_by, restrict, order_by=[])
        results = {}
        Ig::Serveradmin.query(filters, [group_by] + restrict, order_by).each { |cur|
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
        param 'Hash[Ig::Server::Attribute_id, Ig::Server::Query_filter]', :filters
        param 'Ig::Server::Attribute_id', :group_by
        optional_param 'Ig::Server::Attribute_restrict', :restrict
        optional_param 'Array[Ig::Server::Attribute_id]', :order_by
        return_type 'Hash[Ig::Server::Attribute_value, Array[Ig::Server::Attribute_value, 1]]'
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
