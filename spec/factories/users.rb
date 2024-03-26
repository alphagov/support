FactoryBot.define do
  factory :user do
    name { "Stub User" }
    sequence(:email) { |n| "person-#{n}@example.com" }
    permissions { %w[signin] }

    factory(:user_manager) { permissions { %w[signin user_managers] } }
    factory(:content_requester) { permissions { %w[signin content_requesters] } }
    factory(:campaign_requester) { permissions { %w[signin campaign_requesters] } }
    factory(:single_point_of_contact) { permissions { %w[signin single_points_of_contact] } }

    factory :user_who_can_access_everything do
      after(:create) do |user, _|
        def user.has_permission?(*_args)
          true
        end

        def user.can?(*_args)
          true
        end
      end
    end

    factory :user_who_cannot_access_anything do
      after(:create) do |user, _|
        def user.has_permission?(*_args)
          false
        end

        def user.can?(*_args)
          false
        end
      end
    end
  end
end
