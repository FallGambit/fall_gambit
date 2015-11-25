FactoryGirl.define do
  factory :piece do
    id: 15
    x_position: 3
    y_position: 0
    piece_type: Queen
    color: true
    game_id: 1
    user_id: 1
    captured: false
  end
end
