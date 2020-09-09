require "rails_helper"

module Support
  module GDS
    describe RequestedUser do
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:email) }

      it { should allow_value("director").for(:job) }
      it { should allow_value("07911111").for(:phone) }
      it { should allow_value("ab@c.com").for(:email) }
      it { should allow_value("some training").for(:other_training) }
      it { should_not allow_value("ab").for(:email) }
    end
  end
end
