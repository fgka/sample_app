FactoryGirl.define do |binding|

  class << binding
    def current_tenant()
      tenant_id = Thread.current[:tenant_id]
      tenant = nil
      if (!tenant_id.nil?)
        tenant = Tenant.find_by_id(tenant_id)
      end
      if (tenant.nil?)
        tenant_id = FactoryGirl.create(:tenant).id
        Thread.current[:tenant_id] = tenant_id
      end
      tenant_id
    end

    def set_tenant(tenant)
      Thread.current[:tenant_id] = tenant.id
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

    before(:create) { binding.current_tenant }

    factory :admin do
      admin true
    end
  end

  factory :micropost do
    content "Lorem ipsum"
    before(:create) { binding.current_tenant }
  end
end
