require 'spec_helper'

describe Kinja::Post do
  let(:kinja) {
    Kinja::Client.new(
      user: ENV["KINJA_USER"],
      password: ENV["KINJA_PASS"]
  )
  }

  let(:response) {
    VCR.use_cassette('login') do
    kinja.login
    end
  }

  it "retrieves individual posts" do
    VCR.use_cassette('get_post') do
      post = kinja.get_post("1691726561")
      expect(post["data"]["headline"][0...-1]).to eq "Is This Australian TV Anchor Wearing a Dick Or What?"
    end

    VCR.use_cassette('get_post') do
      post = kinja.get_post("http://gawker.com/is-this-australian-tv-anchor-wearing-a-dick-or-what-1691726561")
      expect(post["data"]["headline"][0...-1]).to eq "Is This Australian TV Anchor Wearing a Dick Or What?"
    end
  end

  it "posts stuff" do
    VCR.use_cassette('write-post') do
      post = kinja.create_post(
        headline: '',
        body: '<p>[<a data-attr="http://gawker.com/no-playlist-1685415865" href="http://gawker.com/no-playlist-1685415865">Gawker</a>]</p>',
        status: 'PUBLISHED',
        replies: false
      )
      expect(post.code).to be 200
    end
  end

  it "updates posts" do
    VCR.use_cassette('update-post') do
      link = "http://gemtest.kinja.com/gawker-1710983044"
      post = kinja.update_post(link, publishTimeMillis: DateTime.now.strftime('%Q').to_i)
      expect(post["meta"]["error"]).to be nil
    end
  end

end
