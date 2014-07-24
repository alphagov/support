FactoryGirl.define do
  factory :user do
    name "Stub User"
    sequence(:email) {|n| "person-#{n}@example.com" }
    permissions { [ "signin" ] }

    factory :feedex_user do permissions { [ "signin", "feedex" ] } end
    factory :api_user do permissions { [ "signin", "api_users" ] } end
    factory :user_manager do permissions { [ "signin", "user_managers" ] } end
    factory :content_requester do permissions { [ "signin", "content_requesters" ] } end
    factory :campaign_requester do permissions { [ "signin", "campaign_requesters" ] } end

    factory :user_who_can_access_everything do
      after(:create) do |user, _|
        def user.has_permission?(*args); true; end
        def user.can?(*args); true; end
      end
    end

    factory :user_who_cannot_access_anything do
      after(:create) do |user, _|
        def user.has_permission?(*args); false; end
        def user.can?(*args); false; end
      end
    end
  end
end
