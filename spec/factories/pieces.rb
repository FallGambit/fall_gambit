FactoryGirl.define do
  factory :piece do
    association :game
    x_position 0
    y_position 0
    color false
    captured false
  end

  factory :king, parent: :piece do
    piece_type "King"
    x_position 1
    y_position 1
  end

  factory :knight, parent: :piece do
    piece_type "Knight"
    x_position 2
    y_position 2
  end
end
