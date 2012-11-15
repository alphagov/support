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

  context "when the field isn't provided" do
    should "not apply" do
      data_provider = OpenStruct.new(:my_field_name => nil, :my_field_name? => false)
      assert !CommentSnippet.new(data_provider, :my_field_name).applies?
    end
  end
end