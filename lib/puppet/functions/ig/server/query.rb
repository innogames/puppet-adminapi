#
# Serveradmin query function
#
# Copyright (c) 2018, InnoGames GmbH
#

require 'puppet/util/errors'

require_relative '../../../../ig/server/query'

Puppet::Functions.create_function(:'ig::server::query') do

    dispatch :execute_for_single do
        param 'Hash[Ig::Server::Attribute_id, Ig::Server::Query_filter]', :filters
        optional_param 'Ig::Server::Attribute_id', :restrict
        optional_param 'Array[Ig::Server::Attribute_id]', :order_by
        return_type 'Array[Ig::Server::Attribute_value]'
    end

    def execute_for_single(filters, restrict='hostname', order_by=[])
        Ig::Server::Query.new(filters, [restrict], order_by).get_results().map { |cur|
            cur[restrict]
        }
    end

    dispatch :execute_for_multi do
        param 'Hash[Ig::Server::Attribute_id, Ig::Server::Query_filter]', :filters
        param 'Array[Ig::Server::Attribute_id, 1]', :restrict
        optional_param 'Array[Ig::Server::Attribute_id]', :order_by
        return_type 'Array[Hash[Ig::Server::Attribute_id, Ig::Server::Attribute_value, 1]]'
    end

    def execute_for_multi(filters, restrict, order_by=[])
        Ig::Server::Query.new(filters, restrict, order_by).get_results()
    end
end
