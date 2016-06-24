require 'spec_helper'

describe Kinja::Analytics do
  let(:kinja) {
    Kinja::Client.new
  }

  it "retrieves counts for a post" do
    VCR.use_cassette('get_post_counts') do
      counts = kinja.get_counts(1775111772)
      expect(counts["views"]).to eq 351707
    end
  end

end

