require 'omniauth-oauth'
require 'multi_json'

module OmniAuth
  module Strategies
    class Tqq < OmniAuth::Strategies::OAuth2
      option :name, 'tqq'

      option :client_options, {
        :site           => "https://open.t.qq.com",
        :authorize_url  => "/oauth2/authorize",
        :token_url      => "/oauth2/access_token"
      }
      option :token_params, {
        :parse          => :json
      }

      uid { raw_info['data']['openid'] }

      info do
        {
          :nickname => raw_info['data']['nick'],
          :email => (raw_info['data']['email'] if raw_info['data']['email'].present?),
          :name => raw_info['data']['name'],
          :location => raw_info['data']['location'],
          :image => (raw_info['data']['head']+'/40' if raw_info['data']['head'].present?),
          :description => raw_info['data']['introduction'],
          :urls => {
            'Tqq' => 't.qq.com/' + raw_info['data']['name']
          }
        }
      end

      extra do
        # rename some attribute to my own needs.
        raw_info['gender'] ||= raw_info['data']['sex'] == 1 ? 'm' : (raw_info['data']['sex'] == 2 ? 'f' : '')
        raw_info['followers_count'] ||= raw_info['data']['fansnum']
        raw_info['friends_count'] ||= raw_info['data']['idolnum']
        { :raw_info => raw_info }
      end

      def raw_info
        @raw_info ||= MultiJson.decode(access_token.get('http://open.t.qq.com/api/user/info?format=json&oauth_version=2.a').body)
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
      end

      ##
      # You can pass +display+, +with_offical_account+ or +state+ params to the auth request, if
      # you need to set them dynamically. You can also set these options
      # in the OmniAuth config :authorize_params option.
      #
      # /auth/weibo?display=mobile&with_offical_account=1
      #
      #def authorize_params
        #super.tap do |params|
          #%w[display with_offical_account state].each do |v|
            #if request.params[v]
              #params[v.to_sym] = request.params[v]

              ## to support omniauth-oauth2's auto csrf protection
              #session['omniauth.state'] = params[:state] if v == 'state'
            #end
          #end
        #end
      #end
      
    end
  end
end

OmniAuth.config.add_camelization "tqq", "Tqq"
      #option :name, 'tqq'
      #option :sign_in, true
      #def initialize(*args)
        #super
        ## taken from https://github.com/intridea/omniauth/blob/0-3-stable/oa-oauth/lib/omniauth/strategies/oauth/tqq.rb#L15-24
        #options.client_options = {
          #:access_token_path => '/cgi-bin/access_token',
          #:authorize_path => '/cgi-bin/authorize',
          #:http_method => :get,
          #:nonce => nonce,
          #:realm => 'OmniAuth',
          #:request_token_path => '/cgi-bin/request_token',
          #:scheme => :query_string,
          #:site => 'https://open.t.qq.com',
        #}
      #end

      ## https://github.com/intridea/omniauth/blob/0-3-stable/oa-oauth/lib/omniauth/strategies/oauth/tqq.rb#L28-30
      #def nonce
        #Base64.encode64(OpenSSL::Random.random_bytes(32)).gsub(/\W/, '')[0, 32]
      #end

      #def consumer
        #consumer = ::OAuth::Consumer.new(options.consumer_key, options.consumer_secret, options.client_options)
        #consumer
      #end

      #uid { raw_info['data']['openid'] }

      #info do
        #{
          #:nickname => raw_info['data']['nick'],
          #:email => (raw_info['data']['email'] if raw_info['data']['email'].present?),
          #:name => raw_info['data']['name'],
          #:location => raw_info['data']['location'],
          #:image => (raw_info['data']['head']+'/40' if raw_info['data']['head'].present?),
          #:description => raw_info['data']['introduction'],
          #:urls => {
            #'Tqq' => 't.qq.com/' + raw_info['data']['name']
          #}
        #}
      #end

      #extra do
        ## rename some attribute to my own needs.
        #raw_info['gender'] ||= raw_info['data']['sex'] == 1 ? 'm' : (raw_info['data']['sex'] == 2 ? 'f' : '')
        #raw_info['followers_count'] ||= raw_info['data']['fansnum']
        #raw_info['friends_count'] ||= raw_info['data']['idolnum']
        #{ :raw_info => raw_info }
      #end

      ##taken from https://github.com/intridea/omniauth/blob/0-3-stable/oa-oauth/lib/omniauth/strategies/oauth/tsina.rb#L52-67
      #def request_phase
        #request_token = consumer.get_request_token(:oauth_callback => callback_url)
        #session['oauth'] ||= {}
        #session['oauth'][name.to_s] = {'callback_confirmed' => true, 'request_token' => request_token.token, 'request_secret' => request_token.secret}

        #if request_token.callback_confirmed?
          #redirect request_token.authorize_url(options[:authorize_params])
        #else
          #redirect request_token.authorize_url(options[:authorize_params].merge(:oauth_callback => callback_url))
        #end

      #rescue ::Timeout::Error => e
        #fail!(:timeout, e)
      #rescue ::Net::HTTPFatalError, ::OpenSSL::SSL::SSLError => e
        #fail!(:service_unavailable, e)
      #end

      #def raw_info
        #@raw_info ||= MultiJson.decode(access_token.get('http://open.t.qq.com/api/user/info?format=json').body)
      #rescue ::Errno::ETIMEDOUT
        #raise ::Timeout::Error
      #end
    #end
  #end
#end
