class PageHelper
  def self.fill_content_form
    {:url => '/temp',
     :old_content => 'test content to add',
     :new_content => 'new test content',
     :place_to_remove => 'http://testurl.com',
     :additional => 'additional message',
     :need_by_day => '30',
     :need_by_month => '12',
     :need_by_year => '2012',
     :not_before_day => '31',
     :not_before_month => '12',
     :not_before_year => '2012',
     :name => 'tester',
     :email => 'tester@digital.cabinet-office.gov.uk',
     :department => 'test department',
     :job => 'job',
     :phone => '123456'
    }
  end
end
