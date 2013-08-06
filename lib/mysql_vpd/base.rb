module MysqlVPD
  module Base
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_account
        has_and_belongs_to_many :tenants

        after_create do |new_user|
          tenant = Tenant.find(Thread.current[:tenant_id])
          unless tenant.users.include?(new_user)
            tenant.users << new_user
          end
        end

        before_destroy do |old_user|
          old_user.tenants.clear
          true
        end
      end

      def acts_as_tenant
        has_and_belongs_to_many :users

        before_destroy do |old_tenant|
          old_tenant.users.clear
          true
        end
      end

      def current_tenant
        return Tenant.find(Thread.current[:tenant_id])
      end

      def current_tenant_id
        return Thread.current[:tenant_id]
      end

      def set_current_tenant(tenant)
        case tenant
        when Tenant then tenant_id = tenant.id
        when Integer then tenant_id = tenant
        else raise ArgumentError
        end

        Thread.current[:tenant_id] = tenant_id
      end
    end
  end
end
