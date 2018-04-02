#
# Serveradmin query one object function
#
# Copyright (c) 2018, InnoGames GmbH
#

require 'puppet/util/errors'

require_relative '../../../../ig/server/query'

Puppet::Functions.create_function(:'ig::server::query_one') do

    dispatch :execute do
        param 'Hash[Ig::Server::Attribute_id, Ig::Server::Query_filter]', :filters
        param 'Array[Ig::Server::Attribute_restrict]', :restrict
        return_type 'Hash[Ig::Server::Attribute_id, Ig::Server::Attribute_value]'
    end

    def execute(filters, restrict)
        results = Ig::Server::Query.new(filters, restrict, []).get_results()
        if results.length == 0
            fail('Query returned no objects from Serveradmin!')
        elsif results.length > 1
            fail('Query returned multiple objects from Serveradmin!')
        else
            results[0]
        end
    end

    dispatch :execute_single do
        param 'Hash[Ig::Server::Attribute_id, Ig::Server::Query_filter]', :filters
        optional_param 'Ig::Server::Attribute_restrict', :restrict
        return_type 'Ig::Server::Attribute_value'
    end

    def execute_single(filters, restrict='hostname')
        execute(filters, [restrict])[restrict]
    end
end
