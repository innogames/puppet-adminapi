#
# Serveradmin query and group by an attribute function
#
# Copyright (c) 2018, InnoGames GmbH
#

require 'puppet/util/errors'

require_relative '../../../../ig/server/query'

Puppet::Functions.create_function(:'ig::server::query_group') do

    dispatch :execute_for_single_attribute do
        param 'Hash[Ig::Server::Attribute_id, Ig::Server::Query_filter]', :filters
        param 'Ig::Server::Attribute_id', :group_by
        optional_param 'Ig::Server::Attribute_restrict', :restrict
        optional_param 'Array[Ig::Server::Attribute_id]', :order_by
        return_type 'Hash[Ig::Server::Attribute_value, Array[Ig::Server::Attribute_value, 1]]'
    end

    def execute_for_single_attribute(filters, group_by, restrict='hostname', order_by=[])
        results = {}
        Ig::Server::Query.new(filters, [group_by, restrict], order_by).get_results().each { |cur|
            key = cur[group_by]

            unless results.key? key
                results[key] = []
            end

            results[key].push(cur[restrict])
        }
        results
    end

    dispatch :execute_for_multi_attribute do
        param 'Hash[Ig::Server::Attribute_id, Ig::Server::Query_filter]', :filters
        param 'Ig::Server::Attribute_id', :group_by
        param 'Array[Ig::Server::Attribute_restrict]', :restrict
        optional_param 'Array[Ig::Server::Attribute_id]', :order_by
        return_type 'Hash[Ig::Server::Attribute_value, Array[Hash[Ig::Server::Attribute_id, Ig::Server::Attribute_value], 1]]'
    end

    def execute_for_multi_attribute(filters, group_by, restrict, order_by=[])
        results = {}
        Ig::Server::Query.new(filters, [group_by] + restrict, order_by).get_results().each { |cur|
            key = cur[group_by]

            unless results.key? key
                results[key] = []
            end

            results[key].push(cur.reject { |k|
                k == group_by
            })
        }
        results
    end
end