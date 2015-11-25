FactoryGirl.define do
  factory :game do
    game_name { Faker::Lorem.sentence }
    black_user_id
  end
end
