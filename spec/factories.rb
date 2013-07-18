FactoryGirl.define do |binding|

  class << binding
    def current_tenant()
      Thread.current[:tenant_id] ||= FactoryGirl.create(:tenant).id
    end

    def new_tenant()
      Thread.current[:tenant_id] = FactoryGirl.create(:tenant).id
    end
  end

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
    tenant_id binding.current_tenant
  end
end
