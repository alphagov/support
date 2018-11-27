require 'rails_helper'

module Support
  module GDS
    describe UserFacingComponents do
      it "should find components by name" do
        expect(UserFacingComponents.find("name" => "mainstream_publisher").id).to eq("mainstream_publisher")
      end
    end
  end
end
