class Account < ActiveRecord::Base

  has_and_belongs_to_many :tenants

  attr_accessible :model_id, :model_type

  validates :model_id, presence: true
  validates :model_type, presence: true
  validates :model_id, uniqueness: { scope: :model_type }

  before_destroy :remove_model!

  def self.retrieve_by_model(model)
    m_type = extract_model_type(model)
    m_id = model.id
    result = Account.where(['model_id = :m_id AND model_type = :m_type', { m_id: m_id , m_type: m_type }]).first
  end

  def self.create_by_model(model)
    m_type = extract_model_type(model)
    m_id = model.id
    result = Account.new(model_id: m_id, model_type: m_type)
    result.save!
    result
  end

  private

  def self.extract_model_type(model)
    fail 'nil' if model.nil?
    model.class.to_s
  end

  def remove_model!(model)
    model = Account.retrieve_by_model(model)
    model.destroy!
  end
end
