require "kinja/version"
require 'httparty'

module Kinja
  class Client
    API_ROOT    = "http://kinja.com/api"
    LOGIN_PATH  = "/profile/account/burner/login"
    TOKEN_PATH  = "/profile/token"
    POST_PATH   = "/core/post/add"
    AUTHOR_PATH = "/profile/user/views/asAuthor"

    def initialize(opts={})
      @username = opts[:user]
      @pass = opts[:password]
    end

    def post(opts={})
      opts[:status] = opts[:status] || "DRAFT"
      opts[:replies] = opts[:replies] || true
      api_token(login)

      HTTParty.post "#{API_ROOT}#{POST_PATH}?token=#{@api_token}",
        body: {
          headline: opts[:headline],
          original: opts[:body],
          defaultBlogId: get_default_blog_id(@user),
          status: opts[:status],
          allowReplies: opts[:replies]
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
    end

    def get_author(user)
      HTTParty.get "#{API_ROOT}#{AUTHOR_PATH}?ids=#{user["id"]}"
    end

    def get_default_blog_id(user)
      get_author(user)["data"][0]["defaultBlogId"]
    end

    def login
      response = HTTParty.get "#{API_ROOT}#{LOGIN_PATH}?screenName=#{@username}&token=#{@pass}"
      @user = response["data"]
      response
    end

    def api_token(response)
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
