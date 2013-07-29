class Tenant < ActiveRecord::Base
  attr_accessible :name

  has_and_belongs_to_many :users

  validates :name, presence: true, length: { minimum: 3, maximum: 50 }, uniqueness: { case_sensitive: false }

  def self.create_new_tenant(params)
    tenant = Tenant.create!(name: params[:name])

    return tenant
  end
end
