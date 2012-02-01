# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :chapter, :class => Chapter do
    sequence(:title) {|n| "Chapter title #{n * Time.now.to_i}"}
    sequence(:description) {|n| "Chapter text #{n * Time.now.to_i}"}
    start_time 1
    end_time 2
  end
end
