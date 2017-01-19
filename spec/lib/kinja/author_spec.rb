require 'spec_helper'

describe Kinja::Author do
  let(:kinja) {
    Kinja::Client.new
  }

  it "retrieves an author's profile" do
    VCR.use_cassette('get_author_profile') do
      author = kinja.get_author("id" => "5716491910670767033")
      expect(author[0]["screenName"]).to eq "adampash"
    end
  end

  it "retrieves an author's default blog id" do
    VCR.use_cassette('get_author_default_blog_id') do
      blog_id = kinja.get_default_blog_id("id" => "5716491910670767033")
      expect(blog_id).to eq 771
    end
  end

  it "retrieves an author's author id" do
    VCR.use_cassette('get_author_id') do
      author_id = kinja.get_author_id('adampash')
      expect(author_id).to eq "5716491910670767033"
    end
  end

  it "retrieves an author's posts" do
    VCR.use_cassette(
      'get_author_posts',
      :match_requests_on => [:host, :path]
    ) do
      author_id = "5716491910670767033"
      posts = kinja.get_author_posts(author_id)

      expect(posts["items"].length).to eq 20
    end
  end

  # it "gets all posts and calculates page views" do
  #   id = kinja.get_author_id("sambiddle")
  #   posts = kinja.get_all_author_posts(id)
  #   posts.map do |post|
  #     puts post["post"]["id"]
  #     post["post"]["id"]
  #   end
  # end

end
