require 'spec_helper'

describe Tenant do

  before { @tenant = Tenant.create_new_tenant({name: "Example Tenant"}) }

  subject { @tenant }

  it { should respond_to(:name) }
  it { should respond_to(:tenant) }

  it { should be_valid }

  describe "when name is not present" do
    before { @tenant.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too short" do
    before { @tenant.name = "a" * 2 }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @tenant.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when name is not unique" do
    expect { Tenant.create_new_tenant({name: @tenant.name}) }.to raise_error
  end
end
