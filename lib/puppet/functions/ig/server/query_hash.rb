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
        optional_param 'Ig::Server::Attribute_restrict', :restrict
        return_type 'Hash[Ig::Server::Hostname, Ig::Server::Attribute_value]'
    end

    def execute_for_single(filters, restrict='hostname')
        Ig::Server::Query.new(filters, ['hostname', restrict], []).get_results().reduce({}) { |prev, cur|
            prev[cur['hostname']] = cur[restrict]
        }
    end

    dispatch :execute_for_multi do
        param 'Hash[Ig::Server::Attribute_id, Ig::Server::Query_filter]', :filters
        param 'Array[Ig::Server::Attribute_restrict]', :restrict
        return_type 'Hash[Ig::Server::Hostname, Hash[Ig::Server::Attribute_id, Ig::Server::Attribute_value]]'
    end

    def execute_for_multi(filters, restrict)
        Ig::Server::Query.new(filters, ['hostname'] + restrict, []).get_results().reduce({}) { |prev, cur|
            prev.update(cur['hostname'] => cur.reject { |k|
                k == 'hostname'
            })
        }
    end
end
