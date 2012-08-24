class PageHelper
  def self.fill_content_form
    {:url => '/temp',
     :add_content => 'test content to add',
     :additional => 'additional message',
     :need_by_day => '30',
     :need_by_month => '12',
     :need_by_year => '2012',
     :not_before_day => '31',
     :not_before_month => '12',
     :not_before_year => '2012',
     :name => 'tester',
     :email => 'yu.fu@digital.cabinet-office.gov.uk',
     :department => 'test department',
     :job => 'job',
     :phone => '123456'
    }
  end
end
