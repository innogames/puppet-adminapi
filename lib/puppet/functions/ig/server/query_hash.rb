#
# New serveradmin query function
#
# Copyright (c) 2017, InnoGames GmbH
#

require 'puppet/util/errors'

require_relative '../../../../ig/server/query'

Puppet::Functions.create_function(:'ig::server::query_hash') do

    # Returns single attribute of multiple servers
    # Unlike normal queries it returns a hash by hostname, not a sorted array.
    dispatch :query_hash_single_attr do
        param 'Ig::Igserver_query', :query
        param 'Ig::Attribute_id', :attribute
        return_type 'Hash[Ig::Domain_Name, Ig::Attribute_value]'
    end

    def query_hash_single_attr(query, attribute)
        query_obj = Ig::Server::Query.new(query, ['hostname', attribute])
        query_obj.do_query().reduce({}) { |prev, cur|
            prev[cur['hostname']] = cur[attribute]
        }
    end

    # Returns multiple attributes of a multiple servers
    # Unlike normal queries it returns a hash by hostname, not a sorted array.
    dispatch :query_hash_multi_attr do
        param 'Ig::Igserver_query', :query
        param 'Array[Ig::Attribute_id, 1]', :attributes
        return_type 'Hash[Ig::Domain_Name, Hash[Ig::Attribute_id, Ig::Attribute_value]]'
    end

    def query_hash_multi_attr(query, attributes)
        query_obj = Ig::Server::Query.new(query, ['hostname'] + attributes)
        query_obj.do_query().reduce({}) { |prev, cur|
            prev.update(cur['hostname'] => cur.reject { |k| k == 'hostname'})
        }
    end

end
