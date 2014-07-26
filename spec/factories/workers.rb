# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :worker do
    project
    user
    
    # Need to do this, otherwise the worker gets created but never destroyed as clean up.
    after(:build) {|worker| worker.class.skip_callback(:create, :after, :set_up!) }
    after(:build) {|worker| worker.class.skip_callback(:save, :before, :set_provider!) }
  end
end
