require 'test/unit'
require 'shoulda/context'
require 'ostruct'
require 'comment_snippet'

class CommentSnippetTest < Test::Unit::TestCase
  def snippet(opts)
    CommentSnippet.new(opts)
  end

  def data(opts = {})
    OpenStruct.new(opts)
  end

  context "with a single field" do
    should "format the comment with the provided label" do
      data_provider = data(my_field_name: "abc")
      assert_includes snippet(on: data_provider, field: :my_field_name, label: "Abc").to_s, "[Abc]"
    end

    should "prettify the field name when no label is specified" do
      data_provider = data(my_field_name: "abc")
      assert_includes snippet(on: data_provider, field: :my_field_name).to_s, "[My field name]"
    end

    should "include the field value" do
      data_provider = data(my_field_name: "abc")
      assert_includes snippet(on: data_provider, field: :my_field_name).to_s, "abc"
    end

    should "not apply when the field is not defined" do
      assert !snippet(on: data(), field: :non_existent_field).applies?
    end

    should "not apply when the field value is nil or empty" do
      assert !snippet(on: data(a_nil_field: nil), field: :a_nil_field).applies?
      assert !snippet(on: data(an_empty_field: ""), field: :an_empty_field).applies?
    end
  end

  context "with multiple fields" do
    should "apply only if one of the fields is set" do
      assert snippet(on: data(f1: "abc"), fields: [:f1, :f2], label: "Fields").applies?
      assert snippet(on: data(f1: "abc", f2: "xyz"), fields: [:f1, :f2], label: "Fields").applies?

      assert !snippet(on: data(), fields: [:f1, :f2], label: "Fields").applies?
      assert !snippet(on: data(f1: nil), fields: [:f1, :f2], label: "Fields").applies?
      assert !snippet(on: data(f1: ""), fields: [:f1, :f2], label: "Fields").applies?
    end

    should "concatenate field values with newlines if multiple fields are specified" do
      data_provider = data(f1: "abc", f2: "def", f3: "ghi")
      snippet = snippet(on: data_provider, fields: [:f1, :f2, :f3], label: "Fields")
      assert_includes snippet.to_s, "[Fields]\nabc\ndef\nghi"
    end

    should "concatenate only those field values that are defined" do
      data_provider = data(f1: "abc", f2: nil, f3: "", f4: "def")
      snippet = snippet(on: data_provider, fields: [:f1, :f2, :f3, :f4], label: "Fields")
      assert_includes snippet.to_s, "[Fields]\nabc\ndef"
    end
  end
end