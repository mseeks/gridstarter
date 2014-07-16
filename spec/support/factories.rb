FactoryGirl.define do
  sequence(:date)        { Date.today.advance(days: rand(-100..100)) }
  sequence(:description) { Faker::Lorem.paragraphs(1 + Kernel.rand(5)).join("\n") }
  sequence(:email)       { Faker::Internet.email }
  sequence(:future_date) { rand(100).days.from_now }
  sequence(:hash)        { Faker::Bitcoin.address }
  sequence(:name)        { Faker::Name.name }
  sequence(:number)      { Faker::Number.number(10) }
  sequence(:past_date)   { rand(100).days.ago }
  sequence(:phone)       { Faker::PhoneNumber.phone_number }
  sequence(:progress)    { rand(0.0...99.9) }
  sequence(:string)      { Faker::Lorem.sentence }
  sequence(:job_title)   { Faker::Name.title }
end