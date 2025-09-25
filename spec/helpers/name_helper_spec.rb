require "rails_helper"

describe NameHelper, type: :helper do
  include NameHelper

  describe "#name_for" do
    let(:object_with_no_name) { NameTestObject.new(nil) }
    let(:object_with_name) { NameTestObject.new("object_name") }

    it "returns the name of the form with concatenated bracketed fields" do
      result = name_for(object_with_name, %w[details body])
      expect(result).to eq("object_name[details][body]")

      single_field_result = name_for(object_with_name, %w[test])
      expect(single_field_result).to eq("object_name[test]")
    end

    it "returns nil when the object has no name" do
      expect(object_with_no_name.object_name).to be_blank

      result = name_for(object_with_no_name, %w[test])
      expect(result).to be_nil
    end

    it "returns nil when the fields array is blank" do
      expect(name_for(object_with_name, nil)).to be_nil
      expect(name_for(object_with_name, [])).to be_nil
    end
  end
end

class NameTestObject
  include ActiveModel::Model
  attr_accessor :object_name

  def initialize(object_name)
    @object_name = object_name
  end
end
