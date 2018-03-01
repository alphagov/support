FactoryBot.define do
  factory :user do
    name "Stub User"
    sequence(:email) { |n| "person-#{n}@example.com" }
    permissions { ["signin"] }

    factory :api_user do permissions { %w[signin api_users] } end
    factory :user_manager do permissions { %w[signin user_managers] } end
    factory :content_requester do permissions { %w[signin content_requesters] } end
    factory :campaign_requester do permissions { %w[signin campaign_requesters] } end
    factory :single_point_of_contact do permissions { %w[signin single_points_of_contact] } end

    factory :user_who_can_access_everything do
      after(:create) do |user, _|
        def user.has_permission?(*_args); true; end

        def user.can?(*_args); true; end
      end
    end

    factory :user_who_cannot_access_anything do
      after(:create) do |user, _|
        def user.has_permission?(*_args); false; end

        def user.can?(*_args); false; end
      end
    end
  end
end
