#
# Serveradmin hiera backend
#
# Copyright (c) 2018 InnoGames GmbH
#

require_relative '../../../../ig/serveradmin'

Puppet::Functions.create_function(:'ig::server::hiera_backend') do

    dispatch :execute do
        param 'Hash', :options
        param 'Puppet::LookupContext', :context
    end

    def execute(options, context)
        results = {}
        Ig::Serveradmin.query({'hostname' => closure_scope['trusted']['certname']}, options['restrict'], [])[0].each { |key, value|
            results['ig::server::' + key] = value
        }
        results
    end
end
