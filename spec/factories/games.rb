FactoryGirl.define do
  factory :game do
    game_name { Faker::Lorem.sentence }
    association :white_user, factory: :user
    association :black_user, factory: :user
  end
end
