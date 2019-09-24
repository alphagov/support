# the rspec matchers that ship with cancan now throw deprecation warnigs with rspec3

require "rspec/expectations"

RSpec::Matchers.define :be_able_to do |*args|
  match do |ability|
    ability.can?(*args)
  end

  failure_message do |_ability|
    "expected to be able to #{args.map(&:inspect).join(' ')}"
  end

  failure_message_when_negated do |_ability|
    "expected not to be able to #{args.map(&:inspect).join(' ')}"
  end
end
