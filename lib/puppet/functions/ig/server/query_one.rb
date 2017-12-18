#
# New serveradmin query function
#
# Copyright (c) 2017, InnoGames GmbH
#

require 'puppet/util/errors'

require_relative '../../../../ig/server/query'

Puppet::Functions.create_function(:'ig::server::query_one') do

    # Returns single attribute of single server
    dispatch :query_one_single_attr do
        param 'Hash[Ig::Attribute_id, Ig::Query_filter]', :query
        param 'Ig::Attribute_id', :attribute
        return_type 'Ig::Attribute_value'
    end

    def query_one_single_attr(query, attribute)
        query_obj = Ig::Server::Query.new(query, [attribute])

        ret = query_obj.do_query()
        if ret.length == 0
            fail('Query returned no objects from Serveradmin!')
        elsif ret.length > 1
            fail('Query returned multiple objects from Serveradmin!')
        else
            ret[0][attribute]
        end
    end

    # Returns multiple attributes of a single server
    dispatch :query_one_multi_attr do
        param 'Hash[Ig::Attribute_id, Ig::Query_filter]', :query
        param 'Array[Ig::Attribute_id, 1]', :attributes
        return_type 'Hash[Ig::Attribute_id, Ig::Attribute_value, 1]'
    end

    def query_one_multi_attr(query, attributes)
        query_obj = Ig::Server::Query.new(query, attributes)
        ret = query_obj.do_query()
        if ret.length == 0
            fail('Query returned no objects from Serveradmin!')
        elsif ret.length > 1
            fail('Query returned multiple objects from Serveradmin!')
        else
            ret[0]
        end
    end
end
