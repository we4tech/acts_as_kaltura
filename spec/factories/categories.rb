# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category, :class => Category do
    sequence(:name) {|n| "Cat #{n * Time.now.to_i}"}
    association :user
  end
end
