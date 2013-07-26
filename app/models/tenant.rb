class Tenant < ActiveRecord::Base
  attr_accessible :name

  validates :name, presence: true, length: { minimum: 3, maximum: 50 }, uniqueness: { case_sensitive: false }
end
