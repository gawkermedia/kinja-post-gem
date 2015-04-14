require 'spec_helper'

describe Kinja::Blog do
  let(:kinja) {
    Kinja::Client.new
  }

  it "retrieves posts by blog and tag name" do
    VCR.use_cassette('get_tag_by_blog_id') do
      feed = kinja.tag("game of thrones", 7)
      expect(feed[0]["post"]["headline"].include? "A Closer Look").to be true
    end

    VCR.use_cassette('get_tag_by_blog_name') do
      feed = kinja.tag("game of thrones", "gawker.com")
      expect(feed[0]["post"]["headline"].include? "A Closer Look").to be true
    end
  end

  it "retrieves posts across kinja by tag name" do
    VCR.use_cassette('get_tag') do
      feed = kinja.tag("game of thrones")
      expect(feed[0]["post"]["headline"].include? "HBO Now Review").to be true
    end
  end

end
