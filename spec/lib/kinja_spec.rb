require 'spec_helper'

describe Kinja do
  let(:kinja) {
    Kinja.new(
      user: ENV["KINJA_USER"],
      password: ENV["KINJA_PASS"]
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

end
