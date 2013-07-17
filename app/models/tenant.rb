class Tenant < ActiveRecord::Base
  acts_as_universal_and_determines_tenant
  
  attr_accessible :name

  def self.create_new_tenant(params)
    tenant = Tenant.create!(name: params[:name])

    return tenant
  end
end
