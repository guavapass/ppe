FactoryGirl.define do
  factory :lesson do
    starts_at { Faker::Time.forward(10) }
    duration_in_minutes 60
  end
end
