require 'timecop'
require 'date'
 
Given /^the date is (.+)$/ do |time|
  Timecop.travel Date.parse(time)
end
  
After do
  Timecop.return
end
