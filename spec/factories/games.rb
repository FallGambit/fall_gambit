FactoryGirl.define do
  factory :game do
    game_name { Faker::Lorem.sentence }
  end

end
