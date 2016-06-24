module Kinja
  module Blog
    def get_feed(name_or_id)
      if name_or_id.is_a? String
        feed = get_latest_by_name(name_or_id)
      else
        feed = get_latest_by_id(name_or_id)
      end
      if feed["meta"]["success"]
        feed["data"]["items"]
      else
        feed
      end
    end

    def get_posts_in_month(name_or_id, month="January 2016")
      if name_or_id.is_a? String
        feed = get_latest_by_name(name_or_id)
      else
        feed = get_latest_by_id(name_or_id)
      end
      if feed["meta"]["success"]
        require 'pry'; binding.pry
        feed["data"]["items"]
      else
        feed
      end
    end

    def get_latest_by_id(id)
      HTTParty.get blog_latest_by_id_path(id)
    end

    def get_latest_by_name(name)
      id = get_blog_id(name)
      get_latest_by_id id
    end

    def get_blog_id(name)
      profile = HTTParty.get(blog_profile_path(name))
      profile["data"]["id"]
    end

    def get_members(id)
      members = HTTParty.get(blog_members_path(id))
      members["data"]
    end

  end
end

