#
# Functions required for querying Serveradmin
#
# Copyright (c) 2017 InnoGames GmbH
#

require 'net/http'
require 'uri'
require 'digest'
require 'json'
require 'openssl'

require 'puppet/util/errors'

module Ig::Serveradmin
    def self.query(filters, restrict, order_by)
        application_id = Digest::SHA1.hexdigest(ENV['SERVERADMIN_TOKEN'])
        timestamp = Time.now.getutc.to_i.to_s
        
        query_json = JSON.generate({
            'filters' => filters,
            'restrict' => restrict,
            'order_by' => order_by,
        })

        security_token = OpenSSL::HMAC.hexdigest(
            OpenSSL::Digest.new('sha1'),
            ENV['SERVERADMIN_TOKEN'],
            timestamp + ':' + query_json,
        )

        uri = URI(ENV['SERVERADMIN_BASE_URL'] + '/dataset/query')
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

        if ['2', '3'].include?(res.code[0])
            res_json = JSON.parse(res.body)

            if res_json['status'] && res_json['status'] == 'success' && res_json['result']
                return res_json['result']
            end
        end

        fail('Serveradmin error "' + res.body + '" with HTTP code ' + res.code + ' for ' + payload_json)
    end
end
