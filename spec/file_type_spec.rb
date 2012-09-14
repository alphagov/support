require "test/unit"
require "rack/test"

require_relative "../lib/validations"

class ValidationTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def test_should_return_true_when_file_type_is_valid
    #Given
    file_type_text = "text/csv"
    file_type_word = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    file_type_pdf = "application/pdf"
    field_name = "Uploaded data"

    #When
    is_valid_text = Guard.validate_file_type(field_name,file_type_text)
    is_valid_word = Guard.validate_file_type(field_name, file_type_word)
    is_valid_pdf = Guard.validate_file_type(field_name, file_type_pdf)

    #Then
    assert(is_valid_text)
    assert(is_valid_word)
    assert(is_valid_pdf)
  end

  def test_should_return_false_with_wrong_category
    #Given
    expected_error_message = "Only text, word and pdf file allowed."
    file_type_image = "image/png"
    field_name = "Uploaded data"

    #When
    is_valid = Guard.validate_file_type(field_name, file_type_image)

    #Then
    assert(!is_valid)
  end

  def test_should_return_false_unsupported_type_in_application_category
    #Given
    expected_error_message = "Only text, word and pdf file allowed."
    file_type_image = "application/atom+xml"
    field_name = "Uploaded data"

    #When
    is_valid = Guard.validate_file_type(field_name, file_type_image)

    #Then
    assert(!is_valid)
  end
end