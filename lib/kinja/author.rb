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

    def get_author_posts(id, start=nil, max=20)
      HTTParty.get(author_posts_path(id, start, max))["data"]
    end
  end
end

