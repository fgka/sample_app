class Relationship < ActiveRecord::Base

  acts_as_tenant_based

  attr_accessible :followed_id

  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'

  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
