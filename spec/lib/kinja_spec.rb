require_relative '../../lib/kinja'

require 'vcr'
VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
  config.allow_http_connections_when_no_cassette = true
end

require 'dotenv'
ENV = Dotenv.load

describe Kinja do

  let(:kinja) {
    Kinja::Client.new(
      user: ENV["USER"],
      password: ENV["PASS"]
  )
  }

  let(:response) {
    VCR.use_cassette('login') do
    kinja.login
    end
  }

  it "logs in" do
    expect(response["data"]["id"]).to eq '5876237249235511023'
  end

  it "gets session token from login data" do
    expect(kinja.session_token response).to eq 'a72c7535-20c9-447d-b22c-a502af7be233'
  end

  it "gets an API token" do
    VCR.use_cassette('api-token-test') do
      expect(kinja.get_api_token response).to eq '78c7e184-d9da-4555-b8c3-f488e6a7a343'
    end
  end

  it "gets the author profile" do
    VCR.use_cassette('author-path-er') do
      blog_id = kinja.get_author(response["data"])["data"][0]["defaultBlogId"]
      expect(blog_id).to eq 1634457255
    end
  end

  it "gets the default blog id" do
    VCR.use_cassette('author-path-er') do
      blog_id = kinja.get_default_blog_id(response["data"])
      expect(blog_id).to eq 1634457255
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

  it "retrieves posts" do
    VCR.use_cassette('get_post') do
      post = kinja.get_post("1691726561")
      expect(post["data"]["headline"][0...-1]).to eq "Is This Australian TV Anchor Wearing a Dick Or What?"
    end

    VCR.use_cassette('get_post') do
      post = kinja.get_post("http://gawker.com/is-this-australian-tv-anchor-wearing-a-dick-or-what-1691726561")
      expect(post["data"]["headline"][0...-1]).to eq "Is This Australian TV Anchor Wearing a Dick Or What?"
    end
  end

  it "gets an id from a link" do
    VCR.use_cassette('new_link') do
      new_link = "http://gizmodo.com/how-police-body-cameras-were-designed-to-get-cops-off-t-1691693677/+maxread"
      expect(kinja.get_post_id new_link).to eq "1691693677"
    end

    VCR.use_cassette('old_link') do
      old_link = "http://lifehacker.com/238306/lifehacker-code-texter-windows"
      expect(kinja.get_post_id old_link).to eq "238306"
    end
  end

  it "returns the id if it's passed an id instead of a link" do
    expect(kinja.get_post_id "23432343").to eq "23432343"
  end
end
