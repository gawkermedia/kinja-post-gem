require 'kinja'

module Counts
  def self.author(name)
    kinja = Kinja.new
    id = kinja.get_author_id(name)
    posts = kinja.get_all_author_posts(id)
    post_ids = posts.map do |post|
      puts post["post"]["id"]
      post["post"]["id"]
    end
    counts = post_ids.map do |id|
      kinja.get_counts(id)["views"]
    end

    total = counts.reduce(:+)
  end
end

total = Counts.author("sambiddle")

puts total
