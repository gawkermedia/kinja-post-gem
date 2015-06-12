require 'spec_helper'

describe Kinja do
  let(:kinja) {
    Kinja::Client.new
  }

  it "gets an id from a link" do
    new_link = "http://gizmodo.com/how-police-body-cameras-were-designed-to-get-cops-off-t-1691693677/+maxread"
    expect(kinja.get_post_id new_link).to eq "1691693677"

    old_link = "http://lifehacker.com/238306/lifehacker-code-texter-windows"
    expect(kinja.get_post_id old_link).to eq "238306"

    old_link_nums = "http://lifehacker.com/238306/lifehacker-21-code-texter-windows"
    expect(kinja.get_post_id old_link_nums).to eq "238306"

    multi_nums = "http://theconcourse.deadspin.com/a-21st-century-rip-van-winkle-what-changed-in-my-decad-1691783386/+laceydonohue"
    expect(kinja.get_post_id multi_nums).to eq "1691783386"

    kotaku_bum = "http://kotaku.com/1710975351"
    expect(kinja.get_post_id kotaku_bum).to eq "1710975351"
  end

  it "returns the id if it's passed an id instead of a link" do
    expect(kinja.get_post_id "23432343").to eq "23432343"
  end

  it "has the right update path" do
    # id = "1710957063"
    # expect(Kinja::Helper.update_post_path(id)).to eq 'something'
    # "api/core/post/$id<[0-9]+>/update"
  end
end
