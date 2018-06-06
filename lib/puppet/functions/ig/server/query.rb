#
# Serveradmin query function
#
# Copyright (c) 2018 InnoGames GmbH
#

require 'puppet/util/errors'

require_relative '../../../../ig/serveradmin'

Puppet::Functions.create_function(:'ig::server::query') do

    dispatch :execute do
        param 'Hash[Ig::Server::Attribute_id, Ig::Server::Query_filter]', :filters
        param 'Array[Ig::Server::Attribute_restrict]', :restrict
        optional_param 'Array[Ig::Server::Attribute_id]', :order_by
        return_type 'Array[Hash[Ig::Server::Attribute_id, Ig::Server::Attribute_value]]'
    end

    def execute(filters, restrict, order_by=[])
        Ig::Serveradmin.query(filters, restrict, order_by)
    end

    dispatch :execute_single do
        param 'Hash[Ig::Server::Attribute_id, Ig::Server::Query_filter]', :filters
        optional_param 'Ig::Server::Attribute_restrict', :restrict
        optional_param 'Array[Ig::Server::Attribute_id]', :order_by
        return_type 'Array[Ig::Server::Attribute_value]'
    end

    def execute_single(filters, restrict='hostname', order_by=[])
        attribute = restrict.is_a?(Hash) ? restrict.keys[0] : restrict

        execute(filters, [restrict], order_by).map { |cur|
            cur[attribute]
        }
    end
end
