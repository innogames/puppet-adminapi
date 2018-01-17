#
# Functions required for querying Serveradmin
#
# Copyright (c) 2017, InnoGames GmbH
#

require 'net/http'
require 'uri'
require 'digest'
require 'json'
require 'openssl'

require 'puppet/util/errors'

module Ig
    module Server
        class Query

            def initialize(filters, attributes)
                @filters = filters
                @attributes = attributes
                @serveradmin_url = ENV['SERVERADMIN_BASE_URL'] || 'https://serveradmin.innogames.de/api'
                load_authtoken()
            end

            def load_authtoken()
                fh = File.new('/opt/puppetlabs/server/data/puppetserver/.adminapirc', 'r')
                while (line = fh.gets)
                    line.rstrip!
                    if line.start_with?('auth_token=')
                        @authtoken = line.split('=')[1]
                    end
                end
                fh.close

                if @authtoken.empty?
                    fail('Could not load adminapi auth token!')
                end
            end

            def get_results()
                application_id = Digest::SHA1.hexdigest(@authtoken)
                timestamp = Time.now.getutc.to_i.to_s
                
                query_json = JSON.generate({
                    'filters' => @filters,
                    'restrict' => @attributes,
                    'order_by' => [@attributes[0]],
                })

                security_token = OpenSSL::HMAC.hexdigest(
                    OpenSSL::Digest.new('sha1'),
                    @authtoken,
                    timestamp + ':' + query_json,
                )

                uri = URI(@serveradmin_url + '/dataset/query')
                req = Net::HTTP::Get.new(uri.request_uri)

                req['Content-Encoding'] = 'application/x-json'
                req['X-Timestamp'] = timestamp
                req['X-Application'] = application_id
                req['X-SecurityToken'] = security_token
                req.body = query_json

                res = Net::HTTP.start(
                    uri.host,
                    uri.port,
                    :use_ssl => uri.scheme == 'https'
                ) do |http|
                    http.request(req)
                end

                res_json = JSON.parse(res.body)
                if res_json['status'] && res_json['status'] == 'success' && res_json['result']
                    res_json['result']
                elsif res_json['message']
                    fail('Serveradmin error: "' + res_json['message'] +'"')
                else
                    fail('Could not parse answer from Serveradmin!' + res_json.to_s)
                end
            end

        end
    end
end
