class Tenant < ActiveRecord::Base
  acts_as_universal_and_determines_tenant

  attr_accessible :name

  validates :name, presence: true, length: { minimum: 3, maximum: 50 }, uniqueness: { case_sensitive: false }

  def self.create_new_tenant(params)
    tenant = Tenant.create!(name: params[:name])

    return tenant
  end

  def self.tenant_signup(user, tenant, other = nil)
    StartupJob.queue_startup( tenant, user, other )
  end
end
