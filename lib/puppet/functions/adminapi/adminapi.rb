#
# Functions required for querying Serveradmin
#
# Copyright (c) 2020 InnoGames GmbH
#

require 'net/http'
require 'uri'
require 'digest'
require 'json'
require 'openssl'
require 'timeout'

require 'puppet/util/errors'

module Adminapi
    def self.request(endpoint, payload)
        application_id = Digest::SHA1.hexdigest(ENV['SERVERADMIN_TOKEN'])
        payload_json = JSON.generate(payload)
        uri = URI(ENV['SERVERADMIN_BASE_URL'] + endpoint)

        req = Net::HTTP::Get.new(uri.request_uri)
        req['Content-Encoding'] = 'application/x-json'
        req['X-Application'] = application_id
        req.body = payload_json

        # Ruby 2.x has max_retries implemented, lets change to it once we
        # updated.
        #
        # The Serveradmin backend discards requests which are more than 16
        # seconds in the past or future to avoid timing attacks. We must
        # therefore set the timeout accordingly and make sure we sign the
        # requests with a new timestamp before retrying.
        max_retries = 3
        until max_retries <= 0 do
            begin
                res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https', :open_timeout => 15, :read_timeout => 60) do |http|
                    timestamp = Time.now.getutc.to_i.to_s
                    req['X-Timestamp'] = timestamp
                    req['X-SecurityToken'] = OpenSSL::HMAC.hexdigest(
                        OpenSSL::Digest.new('sha1'),
                        ENV['SERVERADMIN_TOKEN'],
                        timestamp + ':' + payload_json)

                    http.request(req)
                end
            rescue Timeout::Error
                warning('Request to Serveradmin timed out on opening connection or while connected, retrying!')
                sleep 5
                max_retries -= 1
            else
                break
            end
        end

        raise(Puppet::ParseError, "Can't establish connection to Serveradmin") unless max_retries > -1
        raise(Puppet::ParseError, "Serveradmin returned " + res.code + " > " + res.body ) unless res.code[0] == '2'

        res_json = JSON.parse(res.body)

        raise(Puppet::ParseError, "Serveradmin returned no status") unless res_json['status']
        raise(Puppet::ParseError, "Serveradmin returned status " + res_json['status'] + " > " + res.body) unless res_json['status'] == 'success'

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
