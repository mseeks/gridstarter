# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    uid              { generate(:hash) }
    name             { generate(:name) }
    oauth_token      { generate(:hash) }
    oauth_expires_at { generate(:future_date) }
    
    factory :facebook_user do
      provider :facebook
    end
  end
end
