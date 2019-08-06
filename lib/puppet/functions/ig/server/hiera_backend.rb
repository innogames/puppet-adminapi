#
# Serveradmin hiera backend
#
# Copyright (c) 2018 InnoGames GmbH
#

require_relative '../../../../ig/serveradmin'

Puppet::Functions.create_function(:'ig::server::hiera_backend') do
    dispatch :execute do
        param 'Struct[{puppet_class=>String[1], restrict=>Array}]', :options
        param 'Puppet::LookupContext', :context
    end

    argument_mismatch :missing_options do
        param 'Hash', :options
        param 'Puppet::LookupContext', :context
    end

    def execute(options, context)
        results = {}
        Ig::Serveradmin.query({'hostname' => closure_scope['trusted']['certname']}, options['restrict'], [])[0].each { |key, value|
            results[options['puppet_class'] + '::' + key] = value
        }
        results
    end

  def missing_options(options, context)
    if !(options.key? 'puppet_class' and options['puppet_class'].is_a? String)
        err_msg = "'puppet_class' must be declared as a String in hiera.yaml when using this data_hash function"
    else
        err_msg = "'restrict' must be declared as an Array in hiera.yaml when using this data_hash function"
    end
    err_msg
  end
end
