#
# Serveradmin query and group by hostname function
#
# Copyright (c) 2018 InnoGames GmbH
#

require 'puppet/util/errors'

require_relative '../../../../ig/server/query'

Puppet::Functions.create_function(:'ig::server::query_group_hostname') do

    dispatch :execute do
        param 'Hash[Ig::Server::Attribute_id, Ig::Server::Query_filter]', :filters
        param 'Array[Ig::Server::Attribute_restrict]', :restrict
        return_type 'Hash[Ig::Server::Hostname, Hash[Ig::Server::Attribute_id, Ig::Server::Attribute_value]]'
    end

    def execute(filters, restrict)
        Ig::Server::Query.new(filters, ['hostname'] + restrict, []).get_results().reduce({}) { |prev, cur|
            prev.update(cur['hostname'] => cur.reject { |k|
                k == 'hostname'
            })
        }
    end

    dispatch :execute_single do
        param 'Hash[Ig::Server::Attribute_id, Ig::Server::Query_filter]', :filters
        param 'Ig::Server::Attribute_restrict', :restrict
        return_type 'Hash[Ig::Server::Hostname, Ig::Server::Attribute_value]'
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
