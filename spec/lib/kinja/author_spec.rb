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

end
