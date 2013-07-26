class Tenant < ActiveRecord::Base
  attr_accessible :name

  has_and_belongs_to_many :users

  validates :name, presence: true, length: { minimum: 3, maximum: 50 }, uniqueness: { case_sensitive: false }
end
