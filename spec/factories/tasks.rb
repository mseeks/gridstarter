# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do
    worker
    uid { generate(:hash) }
    
    trait :complete do
      progress 100.0
    end
    
    trait :in_progress do
      progress { generate(:progress) }
    end
  end
end
