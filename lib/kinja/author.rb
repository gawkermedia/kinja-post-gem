module Kinja
  module Author
    def get_author(user)
      HTTParty.get(author_path(user["id"]))["data"]
    end

    def get_author_id(name)
      HTTParty.get(author_name_path(name))["data"]["id"]
    end

    def get_default_blog_id(user)
      get_author(user)[0]["defaultBlogId"]
    end

    def get_all_author_posts(id, max=100)
      posts = []
      feed = get_author_posts(id, nil, max)
      posts.push feed["items"]
      next_one = feed["pagination"]["next"]["startTime"]
      loop do
        feed = get_author_posts(id, next_one, max)
        posts.push feed["items"]
        posts = posts.flatten

        break if feed["pagination"]["next"].nil?
        break if posts.length > 100
        next_one = feed["pagination"]["next"]["startTime"]
        puts posts.length
        puts "Getting next one #{next_one}"
      end
      posts.flatten
    end

    def get_author_posts(id, start=nil, max=20)
      HTTParty.get(author_posts_path(id, start, max))["data"]
    end
  end
end

    #
    #
    # def all_in_tag(name, blog=nil)
    #   posts = []
    #   feed = get_posts_in_tag(name)
    #   posts.push feed["data"]["items"]
    #   next_one = feed["data"]["pagination"]["next"]["startTime"]
    #   loop do
    #     if blog.nil?
    #       feed = get_posts_in_tag(
    #         name,
    #         "?startTime=#{next_one}"
    #       )
    #       puts next_one
    #     else
    #       feed = get_posts_in_tag_for_site(name, blog)
    #     end
    #     if feed["meta"]["success"]
    #       posts.push feed["data"]["items"]
    #     else
    #       feed
    #     end
    #     # require 'pry'; binding.pry
    #     break if feed["data"]["pagination"]["next"].nil?
    #     next_one = feed["data"]["pagination"]["next"]["startTime"]
    #   end
    #   posts.flatten
    # end
