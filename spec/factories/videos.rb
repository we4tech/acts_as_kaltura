# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :video, :class => Video do
    sequence(:title) {|n| "Video #{n}"}
    sequence(:description) {|n| "Video description #{n}"}
    video_file { File.open(Rails.root.join('spec', 'fixtures', 'movie2.m4v')) }
  end
end
