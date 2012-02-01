# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :role do
    name "MyString"
    description "MyText"
  end

  factory :admin_role, :parent => :role do
    name 'administrator'
  end

  factory :contributor_role, :parent => :role do
    name 'contributor'
  end
end
