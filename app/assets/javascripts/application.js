// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery-ui/datepicker
//= require_directory ./modules
//= require select2

$(document).ready(function() {
  $('input[name="support_requests_create_or_change_user_request[action]"]').change(function () {
    var displayAdditionalFields = ($(this).val() != "change_user")
    $('#support_requests_create_or_change_user_request_requested_user_attributes_job_input').toggle(displayAdditionalFields);
    $('#support_requests_create_or_change_user_request_requested_user_attributes_phone_input').toggle(displayAdditionalFields);
  });

  $('.dropdown-toggle').dropdown();
  $(".select2").select2();
});
