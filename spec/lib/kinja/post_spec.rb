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
    # VCR.use_cassette('write-post') do
      post = kinja.create_post(
        headline: 'Test',
        body: [{type:"Paragraph",value:[{type:"Text",value:"Begin forwarded message:",styles:[]}],containers:[]},{type:"Paragraph",value:[{type:"Text",value:"From: Gardiner Harris <xxx@nytimes.com<mailto:xxx@nytimes.com>>",styles:[]},{type:"LineBreak"},{type:"Text",value:"Date: November 15, 2016 at 11:08:05 AM GMT+2",styles:[]},{type:"LineBreak"},{type:"Text",value:"To: xxx@who.eop.gov<mailto:xxx@who.eop.gov>",styles:[]},{type:"LineBreak"},{type:"Text",value:"Subject: Motorcade moving; pool 3",styles:[]}],containers:[]},{type:"Paragraph",value:[{type:"Text",value:"The motorcade is rolling through blocked off highways and streets into",styles:[]},{type:"LineBreak"},{type:"Text",value:"central Athens, dry hillsides and occasional groves of olive trees and",styles:[]},{type:"LineBreak"},{type:"Text",value:"dry dock boatyards on either side.",styles:[]}],containers:[]},{type:"Paragraph",value:[{type:"Text",value:"Gardiner Harris",styles:[]},{type:"LineBreak"},{type:"Text",value:"White House Correspondent",styles:[]},{type:"LineBreak"},{type:"Text",value:"The New York Times",styles:[]},{type:"LineBreak"},{type:"Text",value:"1627 I Street NW",styles:[]},{type:"LineBreak"},{type:"Text",value:"Washington DC 20006",styles:[]},{type:"LineBreak"},{type:"Text",value:"Desk: +202-xxx-xxxx",styles:[]},{type:"LineBreak"},{type:"Text",value:"Cell: +202-xxx-xxxx",styles:[]},{type:"LineBreak"},{type:"Text",value:"xxx@nytimes.com<mailto:xxx@nytimes.com>",styles:[]}],containers:[]},{type:"Paragraph",value:[{type:"Text",value:"-----",styles:[]}],containers:[]},{type:"Paragraph",value:[{type:"Text",value:"Unsubscribe [ http://messages.whitehouse.gov/accounts/USEOPWHPO/subscriber/new?preferences=true ]",styles:[]}],containers:[]},{type:"Paragraph",value:[{type:"Text",value:"The White House · 1600 Pennsylvania Avenue, NW · Washington DC 20500 · 202-xxx-xxxx",styles:[]}],containers:[]},{style:"Line",containers:[],type:"HorizontalRule"},{containers:[],value:[{styles:["Italic"],value:"Public Pool is an automated feed of ",type:"Text"},{"reference":"http://politburo.kinja.com/here-are-all-the-white-house-pool-reports-1691913651",value:[{styles:["Italic"],value:"White House press pool reports",type:"Text"}],type:"Link"},{styles:["Italic"],value:". For live updates, follow ",type:"Text"},{"reference":"https://twitter.com/whpublicpool",value:[{styles:["Italic"],value:"@WHPublicPool",type:"Text"}],type:"Link"},{styles:["Italic"],value:" on Twitter.",type:"Text"}],type:"Paragraph"}],
        status: 'DRAFT',
        replies: false
      )
      puts post
      expect(post.code).to be 200
    # end
  end

  it "updates posts" do
    VCR.use_cassette('update-post') do
      link = "http://gemtest.kinja.com/gawker-1710983044"
      post = kinja.update_post(link, publishTimeMillis: DateTime.now.strftime('%Q').to_i)
      expect(post["meta"]["error"]).to be nil
    end
  end

end
