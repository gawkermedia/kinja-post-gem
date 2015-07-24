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
    expect(kinja.session_token response).to eq 'cdcca983-a1a7-4765-8e37-6624198b1699'
  end

  it "gets an API token" do
    VCR.use_cassette('api-token-test') do
      expect(kinja.get_api_token response).to eq 'd4e084be-77ed-4bc6-ab0d-248a5f047df8-0-d367eb4abb79931841acb749fe64012f9a4f0d1d'
    end
  end

end
