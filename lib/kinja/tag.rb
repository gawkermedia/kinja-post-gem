module Kinja
  module Tag
    def tag(name, blog=nil)
      if blog.nil?
        feed = get_posts_in_tag(name)
      else
        feed = get_posts_in_tag_for_site(name, blog)
      end
      if feed["meta"]["success"]
        feed["data"]["items"]
      else
        feed
      end
    end

    def all_in_tag(name, blog=nil)
      posts = []
      feed = get_posts_in_tag(name)
      posts.push feed["data"]["items"]
      next_one = feed["data"]["pagination"]["next"]["startTime"]
      loop do
        if blog.nil?
          feed = get_posts_in_tag(
            name,
            "?startTime=#{next_one}"
          )
          puts next_one
        else
          feed = get_posts_in_tag_for_site(name, blog)
        end
        if feed["meta"]["success"]
          posts.push feed["data"]["items"]
        else
          feed
        end
        # require 'pry'; binding.pry
        break if feed["data"]["pagination"]["next"].nil?
        next_one = feed["data"]["pagination"]["next"]["startTime"]
      end
      posts.flatten
    end

    def get_posts_in_tag(name, params="")
      HTTParty.get "#{tag_path(name)}#{params}"
    end

    def get_tag_feed_for_site(name, blog_id, params="")
      HTTParty.get tag_and_blog_path(name, blog_id)
    end

    def get_posts_in_tag_for_site(name, blog_name_or_id)
      if blog_name_or_id.is_a? String
        get_tag_feed_for_site name, get_blog_id(blog_name_or_id)
      else
        get_tag_feed_for_site(name, blog_name_or_id)
      end
    end
  end
end


