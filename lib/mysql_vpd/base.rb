module MysqlVPD
  module Base

    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      def acts_as_account

        after_create do |model|
          self.class.add_model_to_current_tenant(model)
          true
        end

        before_destroy do |model|
          self.class.remove_model(model)
          true
        end
      end

      def defines_account

      end

      def acts_as_tenant
        has_and_belongs_to_many :accounts

        before_destroy do |old_tenant|
          old_tenant.accounts.clear
          true
        end
      end

      def set_current_tenant(tenant)
        set_tenant tenant
      end

      def add_model_to_current_tenant(model)
        tenant = current_tenant
        new_account = Account.create_by_model(model)
        unless tenant.accounts.include?(new_account)
          new_account.save!
          tenant.accounts << new_account
        end
      end

      def remove_model(model)
        account = Account.retrieve_by_model(model)
        unless account.nil? do
          account.tenants.clear
          account.destroy!
        end
        end
      end
    end
  end
end
