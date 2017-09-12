require 'spec_helper'
require 'ostruct'

describe Zendesk::LabelledSnippet do
  def snippet(opts)
    Zendesk::LabelledSnippet.new(opts)
  end

  def data(opts = {})
    OpenStruct.new(opts)
  end

  context "with a single field" do
    it "formats the comment with the provided label" do
      data_provider = data(my_field_name: "abc")
      expect(snippet(on: data_provider, field: :my_field_name, label: "Abc").to_s).to include("[Abc]")
    end

    it "prettifies the field name when no label is specified" do
      data_provider = data(my_field_name: "abc")
      expect(snippet(on: data_provider, field: :my_field_name).to_s).to include("[My field name]")
    end

    it "includes the field value" do
      data_provider = data(my_field_name: "abc")
      expect(snippet(on: data_provider, field: :my_field_name).to_s).to include("abc")
    end

    it "doesn't apply when the field is not defined" do
      expect(snippet(on: data, field: :non_existent_field).applies?).to be_falsey
    end

    it "doesn't apply when the field value is nil or empty" do
      expect(snippet(on: data(a_nil_field: nil), field: :a_nil_field).applies?).to be_falsey
      expect(snippet(on: data(an_empty_field: ""), field: :an_empty_field).applies?).to be_falsey
    end
  end

  context "with multiple fields" do
    it "apples only if one of the fields is set" do
      expect(snippet(on: data(f1: "abc"), fields: %i[f1 f2], label: "Fields").applies?).to be_truthy
      expect(snippet(on: data(f1: "abc", f2: "xyz"), fields: %i[f1 f2], label: "Fields").applies?).to be_truthy

      expect(snippet(on: data, fields: %i[f1 f2], label: "Fields").applies?).to be_falsey
      expect(snippet(on: data(f1: nil), fields: %i[f1 f2], label: "Fields").applies?).to be_falsey
      expect(snippet(on: data(f1: ""), fields: %i[f1 f2], label: "Fields").applies?).to be_falsey
    end

    it "concatenates field values with newlines if multiple fields are specified" do
      data_provider = data(f1: "abc", f2: "def", f3: "ghi")
      snippet = snippet(on: data_provider, fields: %i[f1 f2 f3], label: "Fields")
      expect(snippet.to_s).to include("[Fields]\nabc\ndef\nghi")
    end

    it "concatenates only those field values that are defined" do
      data_provider = data(f1: "abc", f2: nil, f3: "", f4: "def")
      snippet = snippet(on: data_provider, fields: %i[f1 f2 f3 f4], label: "Fields")
      expect(snippet.to_s).to include("[Fields]\nabc\ndef")
    end
  end
end
