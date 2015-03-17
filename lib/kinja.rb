require "kinja/version"
require 'httparty'

module Kinja
  class Client
    attr_accessor :user

    API_ROOT    = "http://kinja.com/api"
    LOGIN_PATH  = "/profile/account/burner/login"
    TOKEN_PATH  = "/profile/token"
    CREATE_POST_PATH   = "/core/post/add"
    POST_PATH   = "/core/post"
    AUTHOR_PATH = "/profile/user/views/asAuthor"

    def initialize(opts={})
      @username = opts[:user]
      @pass = opts[:password]
    end

    def create_post(opts={})
      get_api_token(login)
      opts[:status] = opts[:status] || "DRAFT"
      opts[:replies] = opts[:replies] || true
      opts[:defaultBlogId] = opts[:defaultBlogId] || get_default_blog_id(@user)

      HTTParty.post "#{API_ROOT}#{CREATE_POST_PATH}?token=#{@api_token}",
        body: {
          headline: opts[:headline],
          original: opts[:body],
          defaultBlogId: opts[:defaultBlogId],
          status: opts[:status],
          allowReplies: opts[:replies]
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
    end

    def update_post(link_or_id, opts)
      get_api_token(login)

      id = get_post_id link_or_id
      opts[:defaultBlogId] = opts[:defaultBlogId] || get_default_blog_id(@user)
      HTTParty.post "#{API_ROOT}#{POST_PATH}/#{id}/update?token=#{@api_token}",
        body: opts.to_json,
        headers: { 'Content-Type' => 'application/json' }
    end

    def get_post(link_or_id)
      id = get_post_id link_or_id
      HTTParty.get "#{API_ROOT}#{POST_PATH}/#{id}"
    end

    def get_post_id(link)
      return link if link.match(/^\d+$/)
      new_link_re = /-(\d+)\/?/
      old_link_re = /\.com\/(\d+)\//
      return link.match(new_link_re)[1] if link.match(new_link_re)
      return link.match(old_link_re)[1] if link.match(old_link_re)
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
