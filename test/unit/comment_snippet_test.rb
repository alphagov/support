require 'test/unit'
require 'shoulda/context'
require 'ostruct'
require 'comment_snippet'

class CommentSnippetTest < Test::Unit::TestCase
  should "prettify the field name" do
    data_provider = OpenStruct.new(:my_field_name => "abc")
    assert_includes CommentSnippet.new(data_provider, :my_field_name).to_s, "[My field name]"
  end

  should "include the field value" do
    data_provider = OpenStruct.new(:my_field_name => "abc")
    assert_includes CommentSnippet.new(data_provider, :my_field_name).to_s, "abc"    
  end

  context "when the field isn't provided or is empty" do
    should "not apply" do
      data_provider = OpenStruct.new(:a_nil_field => nil, :an_empty_field => "")
      assert !CommentSnippet.new(data_provider, :a_nil_field).applies?
      assert !CommentSnippet.new(data_provider, :an_empty_field).applies?
    end
  end
end