# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user, :class => User do
    sequence(:email) {|n| "holatest#{n}@swi.com"}
    password "123456"
    password_confirmation "123456"
  end

  factory :admin_user, :parent => :user do
    after_create { |user| user.roles << FactoryGirl.create(:admin_role) }
  end

  factory :contributor_user, :parent => :user do
    after_create { |user| user.roles << FactoryGirl.create(:contributor_role) }
  end
end
