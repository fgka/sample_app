class Account < ActiveRecord::Base
  attr_accessible :model_id, :model_type

  before_destroy :remove_model!

  def self.retrieve_by_model(model)
    #TODO get from tenants_accounts based on model.id and model."name" make it a symbol and query
    #Account.find_by_id_and_type(model."name", model.id)
  end

  def self.create_by_model(model)
    #TODO extract model.id and model."name"
    #Account.create!(model.id, model."name")
  end

  private

  def remove_model!(model)
    model = Account.retrieve_by_model(model)
    model.destroy!
  end
end
