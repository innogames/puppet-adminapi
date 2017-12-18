#
# Serveradmin query and hash function
#
# Copyright (c) 2018, InnoGames GmbH
#

require 'puppet/util/errors'

require_relative '../../../../ig/server/query'

Puppet::Functions.create_function(:'ig::server::query_hash') do

    dispatch :execute_for_single do
        param 'Hash[Ig::Server::Attribute_id, Ig::Server::Query_filter]', :filters
        param 'Ig::Server::Attribute_id', :restrict
        return_type 'Hash[Ig::Domain_Name, Ig::Server::Attribute_value]'
    end

    def execute_for_single(filters, restrict)
        Ig::Server::Query.new(filters, ['hostname', restrict], []).get_results().reduce({}) { |prev, cur|
            prev[cur['hostname']] = cur[restrict]
        }
    end

    dispatch :execute_for_multi do
        param 'Hash[Ig::Server::Attribute_id, Ig::Server::Query_filter]', :filters
        param 'Array[Ig::Attribute_id, 1]', :restrict
        return_type 'Hash[Ig::Domain_Name, Hash[Ig::Server::Attribute_id, Ig::Server::Attribute_value]]'
    end

    def execute_for_multi(filters, restrict)
        Ig::Server::Query.new(filters, ['hostname'] + restrict, []).get_results().reduce({}) { |prev, cur|
            prev.update(cur['hostname'] => cur.reject { |k|
                k == 'hostname'
            })
        }
    end
end
