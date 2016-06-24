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
