# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    name "LHC@home"
    url "http://lhcathome.web.cern.ch"
    work_type "boinc"
  end
end
