#
# Functions required for querying Serveradmin
#
# Copyright (c) 2019 InnoGames GmbH
#

require 'net/http'
require 'uri'
require 'digest'
require 'json'
require 'openssl'

require 'puppet/util/errors'

module Adminapi
    def self.request(endpoint, payload)
        application_id = Digest::SHA1.hexdigest(ENV['SERVERADMIN_TOKEN'])
        timestamp = Time.now.getutc.to_i.to_s
        payload_json = JSON.generate(payload)
        uri = URI(ENV['SERVERADMIN_BASE_URL'] + endpoint)

        req = Net::HTTP::Get.new(uri.request_uri)
        req['Content-Encoding'] = 'application/x-json'
        req['X-Timestamp'] = timestamp
        req['X-Application'] = application_id
        req['X-SecurityToken'] = OpenSSL::HMAC.hexdigest(
            OpenSSL::Digest.new('sha1'),
            ENV['SERVERADMIN_TOKEN'],
            timestamp + ':' + payload_json,
        )
        req.body = payload_json

        res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
            http.request(req)
        end

        raise(Puppet::ParseError, "Serveradmin retuned " + res.code) unless res.code[0] == '2'

        res_json = JSON.parse(res.body)

        raise(Puppet::ParseError, "Serveradmin retuned no status") unless res_json['status']
        raise(Puppet::ParseError, "Serveradmin retuned status " + res_json['status']) unless res_json['status'] == 'success'

        return res_json['result']
    end

    def self.query(filters, restrict, order_by)
        request('/dataset/query', {
            'filters'  => filters,
            'restrict' => restrict,
            'order_by' => order_by,
        })
    end

    def self.commit(created, changed, deleted)
        request('/dataset/commit', {
            'created' => created,
            'changed' => changed,
            'deleted' => deleted,
        })
    end
end
