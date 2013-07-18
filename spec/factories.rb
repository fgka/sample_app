module FactoryGirl
  module TenantHelper    
    def self.current_tenant()
      return Thread.current[:tenant_id]
    end
  end
end

FactoryGirl.define do

  factory :tenant do
    sequence(:name) { |n| "Tenant #{n}"}
    sequence(:id) { |n| n }
    tenant_id nil
  end

  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"
    tenant_id nil

    factory :admin do
      admin true
    end
  end

  factory :micropost do
    content "Lorem ipsum"
    user
    tenant_id FactoryGirl::TenantHelper::current_tenant
  end
end
