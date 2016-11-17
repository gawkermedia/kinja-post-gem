module Kinja
  module Post
    def get_post(link_or_id)
      id = get_post_id link_or_id
      HTTParty.get post_path(id)
    end

    def create_post(opts={})
      get_api_token(login)
      opts[:status] = opts[:status] || "DRAFT"
      opts[:replies] = opts[:replies] || true
      opts[:defaultBlogId] = opts[:defaultBlogId] || get_default_blog_id(@user)

      HTTParty.post create_post_path,
        body: {
          headline: opts[:headline],
          body: opts[:body],
          defaultBlogId: opts[:defaultBlogId],
          status: opts[:status],
          allowReplies: opts[:replies],
          tags: []
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
    end

    def update_post(link_or_id, opts)
      get_api_token(login)

      id = get_post_id link_or_id
      opts[:defaultBlogId] = opts[:defaultBlogId] || get_default_blog_id(@user)
      HTTParty.post update_post_path(id),
        body: opts.to_json,
        headers: { 'Content-Type' => 'application/json' }
    end

  end
end
