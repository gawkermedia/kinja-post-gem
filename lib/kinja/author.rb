module Kinja
  module Author
    def get_author(user)
      HTTParty.get(author_path(user["id"]))["data"]
    end

    def get_default_blog_id(user)
      get_author(user)[0]["defaultBlogId"]
    end
  end
end

