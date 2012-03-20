FactoryGirl.define do
  factory :company_1, :class => Company do
    sequence(:name) {|n| "company #{n}"}
    sequence(:address) {|n| "company #{n} address"}
    sequence(:email) {|n| "company#{n}@swi.net"}
    sequence(:contact) {|n| "#{n}"}
    after_build {|company| company.setting = Factory(:setting_1)}
  end

  factory :company_2, :class => Company do
    sequence(:name) {|n| "company #{n}"}
    sequence(:address) {|n| "company #{n} address"}
    sequence(:email) {|n| "company#{n}@swi.net"}
    sequence(:contact) {|n| "#{n}"}
  end
end
