#
# New serveradmin query function
#
# Copyright (c) 2017, InnoGames GmbH
#

require 'puppet/util/errors'

require_relative '../../../../ig/server/query'

Puppet::Functions.create_function(:'ig::server::query') do

    # Returns single attribute of multiple servers
    dispatch :query_single_attr do
        param 'Hash[Ig::Attribute_id, Ig::Query_filter]', :query
        optional_param 'Ig::Attribute_id', :attribute
        return_type 'Array[Ig::Attribute_value]'
    end

    def query_single_attr(query, attribute='hostname')
        query_obj = Ig::Server::Query.new(query, [attribute])
        ret = query_obj.do_query()
        # No checking for number of returned hosts.
        # This function is *not* query_one.
        ret.map { |sa_obj|
            sa_obj[attribute]
        }
    end

    # Returns multiple attributes of a multiple servers
    dispatch :query_multi_attr do
        param 'Hash[Ig::Attribute_id, Ig::Query_filter]', :query
        param 'Array[Ig::Attribute_id, 1]', :attributes
        return_type 'Array[Hash[Ig::Attribute_id, Ig::Attribute_value, 1]]'
    end

    def query_multi_attr(query, attributes)
        query_obj = Ig::Server::Query.new(query, attributes)
        # No checking for number of returned hosts.
        # This function is *not* query_one.
        query_obj.do_query()
    end
end
