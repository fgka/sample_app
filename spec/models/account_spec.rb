require 'spec_helper'

describe Account do

  before do
    set_tenant Tenant.create_new_tenant(name: Faker::Name.name)
  end

  describe 'model must validate fields' do
    let(:account) { Account.new(model_id: 1, model_type: 'User') }

    subject { account }

    it { should respond_to(:model_id) }
    it { should respond_to(:model_type) }
    it { should be_valid }
  end


  describe 'when creating using appropriated class method' do
    let(:user) { FactoryGirl.build(:user, id: rand) }
    let(:account) { Account.create_by_model(user) }

    subject { account }

    it { should be_valid }

    describe 'must acquire model\'s correct properties' do
      its(:model_id) { should eql user.id }
      its(:model_type) { should eql user.class.to_s }
    end

    it 'must not accept duplicate an entry for the same model' do
      expect do
        Account.create_by_model(user)
        Account.create_by_model(user)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    describe 'must be able to return the stored model' do
      let(:retrieved_account) { Account.retrieve_by_model(user) }

      subject { retrieved_account }

      it { should eql account }
    end
  end
end
