(function(Modules) {
  "use strict";
  /*
     Initialise a jQuery UI date picker
     https://jqueryui.com/datepicker/
  */
  Modules.Calendar = function() {
    this.start = function(element) {

      // Date format: https://jqueryui.com/datepicker/#date-formats
      // Min and max dates: https://jqueryui.com/datepicker/#min-max
      var options = {
            dateFormat: element.data('format') || 'd M yy'
          },
          maxDate = element.data('max-date'),
          minDate = element.data('min-date');

      if (typeof maxDate === "number") {
        options.maxDate = maxDate;
      }

      if (typeof minDate === "number") {
        options.minDate = minDate;
      }

      // Create jQuery UI date picker
      element.datepicker(options);
    }
  };
})(window.GOVUKAdmin.Modules);
