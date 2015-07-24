module Kinja
  module Helper
    def get_post_id(link)
      return link if link.match(/^\d+$/)
      new_link_re = /-?(\d{8,11})\/?/
      old_link_re = /\.com\/(\d+)\//
      return link.match(new_link_re)[1] if link.match(new_link_re)
      return link.match(old_link_re)[1] if link.match(old_link_re)
    end

    private
    API_ROOT    = "http://kinja.com/api"
    LOGIN_PATH  = "/profile/session/burnerLogin"
    TOKEN_PATH  = "/profile/token/create"
    CREATE_POST_PATH   = "/core/post/add"
    POST_PATH   = "core/post"
    BLOG_PATH   = "core/blog"
    TAG_PATH    = "core/tag"
    BLOG_PROFILE_PATH   = "profile/blog/byhost"
    AUTHOR_PATH = "profile/user/views/asAuthor"

    def post_path(id)
      "#{API_ROOT}/#{POST_PATH}/#{id}"
    end

    def create_post_path
      "#{API_ROOT}#{CREATE_POST_PATH}?token=#{@api_token}"
    end

    def update_post_path(id)
      "#{API_ROOT}/#{POST_PATH}/#{id}/update?token=#{@api_token}"
    end


    def blog_latest_by_id_path(id)
      "#{API_ROOT}/#{BLOG_PATH}/#{id}/latest"
    end
    def blog_profile_path(name)
      "#{API_ROOT}/#{BLOG_PROFILE_PATH}/#{name}"
    end

    def tag_path(name)
      "#{API_ROOT}/#{TAG_PATH}/#{URI.encode name}"
    end

    def tag_and_blog_path(name, blog_id)
      "#{API_ROOT}/#{BLOG_PATH}/#{blog_id}/tag/#{URI.encode name}"
    end

    def author_path(id)
      "#{API_ROOT}/#{AUTHOR_PATH}?ids=#{id}"
    end

  end
end

