require "kinja/post"
require "kinja/blog"
require "kinja/author"
require "kinja/tag"
require "kinja/helpers"
require 'httparty'

module Kinja
  class Client
    attr_accessor :user
    include Kinja::Post
    include Kinja::Blog
    include Kinja::Author
    include Kinja::Tag
    include Kinja::Helper

    def initialize(opts={})
      if opts.has_key? :user and opts.has_key? :password
        @username = opts[:user]
        @pass = opts[:password]
      end
    end

    def login
      response = HTTParty.get "#{API_ROOT}#{LOGIN_PATH}?screenName=#{URI.encode @username}&token=#{URI.encode @pass}"
      @user = response["data"]
      response
    end

    def get_api_token(response)
      @api_token = HTTParty.get("#{API_ROOT}#{TOKEN_PATH}",
        cookies: {KinjaSession: session_token(response)}
                  )['data']['token']
    end

    def session_token(response)
      re = /KinjaSession=([\w-]+);/
      response.headers["set-cookie"].match(re)[1]
    end
  end
end
