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

    def get_posts_in_tag(name)
      HTTParty.get tag_path(name)
    end

    def get_tag_feed_for_site(name, blog_id)
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


