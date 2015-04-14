require 'spec_helper'

describe Kinja::Blog do
  let(:kinja) {
    Kinja::Client.new
  }

  it "retrieves a blog's feed by id" do
    VCR.use_cassette('get_feed_by_id') do
      feed = kinja.get_feed(7)
      expect(feed[0]["post"]["headline"].include? "You Are Paying Billions").to be true
    end
  end

  it "retrieves a blog's id" do
    VCR.use_cassette('get_blog_id') do
      id = kinja.get_blog_id("gawker.com")
      expect(id).to eq 7
    end
  end

  it "retrieves a blogs' feed by blog name" do
    VCR.use_cassette('get_feed_by_name') do
      feed = kinja.get_feed("gawker.com")
      expect(feed[0]["post"]["headline"].include? "Strong Storms").to be true
    end
  end

end
