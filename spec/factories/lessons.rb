FactoryGirl.define do
  factory :lesson do
    starts_at { Faker::Time.forward(10) }
    duration_in_minutes 60
    description { Faker::Lorem.sentence }
    studio_name { Faker::Company.name }
  end
end
