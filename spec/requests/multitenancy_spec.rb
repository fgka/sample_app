require 'spec_helper'

describe 'Multitenant Microposts' do

  subject { page }

  describe 'micropost from one tenant shall not be visible by another' do

    let(:tenantA) { FactoryGirl.create(:tenant) }
    let(:tenantB) { FactoryGirl.create(:tenant) }
    let(:userA) do
      set_tenant tenantA
      FactoryGirl.create(:user)
    end
    let(:userB) do
      set_tenant tenantB
      FactoryGirl.create(:user)
    end
    let!(:mA) do
      set_tenant tenantA
      FactoryGirl.create(:micropost, user: userA, content: 'Tenant A post')
    end
    let!(:mB) do
      set_tenant tenantB
      FactoryGirl.create(:micropost, user: userB, content: 'Tenant B post')
    end

    describe 'but userA should be able to see own microposts' do
      before do
        sign_in userA
        visit user_path(userA)
      end

      describe 'microposts' do
        it { should have_content(mA.content) }
        it { should have_content(userA.microposts.count) }
      end
    end

    describe 'userA should NOT be able to see userB microposts' do
      before do
        sign_in userA
        visit user_path(userB)
      end

      describe 'microposts' do
        it { should_not have_content(mB.content) }
      end
    end
  end
end
