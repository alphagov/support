describe('A calendar module', function() {
  "use strict";

  var calendar,
      $el;

  beforeEach(function() {
    $el = $('<div>');
    $('body').append($el);
    calendar = new GOVUKAdmin.Modules.Calendar();
    spyOn($el, 'datepicker');
  });

  afterEach(function() {
    $el.remove();
  });

  describe('when started', function() {
    it('creates a jquery UI datepicker with friendly date format' , function() {
      calendar.start($el);
      expect($el.datepicker).toHaveBeenCalledWith({dateFormat: 'd M yy'});
    });

    it('accepts custom date formats', function() {
      $el.data('format', 'dd/mm/yy');
      calendar.start($el);
      expect($el.datepicker).toHaveBeenCalledWith({dateFormat: 'dd/mm/yy'});
    });

    it('accepts min and max date options', function() {
      $el.data('min-date', 0);
      $el.data('max-date', 0);
      calendar.start($el);
      expect($el.datepicker).toHaveBeenCalledWith({dateFormat: 'd M yy', minDate: 0, maxDate: 0});
    });
  });

});
