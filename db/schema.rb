# encoding: UTF-8

ActiveRecord::Schema.define(:version => 0) do
  create_table "requesters", :force => true do |t|
    t.string :name
    t.string :email
    t.string :job
    t.string :phone
    t.string :organisation
    t.string :other_organisation
  end

  create_table "general_requests", :force => true do |t|
    t.integer :requester_id
    t.string  :url
    t.string  :additional
    t.string  :user_agent
  end
end
