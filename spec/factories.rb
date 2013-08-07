FactoryGirl.define do |binding|

  class << binding

    include MysqlVPD::TenantHelper

    def bind_current_tenant()
      tenant = current_tenant
      if tenant.nil?
        tenant = FactoryGirl.create(:tenant)
        set_tenant tenant
      end
      tenant.id
    end
  end

  factory :tenant do
    sequence(:name) { |n| "Tenant #{n}"}
  end

  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    before(:create) { binding.bind_current_tenant }

    factory :admin do
      admin true
    end
  end

  factory :micropost do
    content "Lorem ipsum"
    before(:create) { binding.bind_current_tenant }
  end
end
