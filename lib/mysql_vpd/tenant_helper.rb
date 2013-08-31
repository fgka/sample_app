module MysqlVPD
  module TenantHelper
    def self.included(base)
      base.send :extend, ClassMethods
    end

    def set_tenant(tenant)
      self.class.set_tenant tenant
    end

    def current_tenant
      self.class.current_tenant
    end

    def current_tenant_id
      self.class.current_tenant_id
    end

    def log_debug(msg)
      self.class.log_debug msg
    end

    module ClassMethods
      def current_tenant
        tenant = nil
        tenant_id = current_tenant_id
        unless tenant_id.nil?
          tenant = Tenant.find_by_id(tenant_id)
        end
        tenant
      end

      def current_tenant_id
        return Thread.current[:tenant_id]
      end

      def set_tenant(tenant)
        case tenant
        when Tenant then tenant_id = tenant.id
        when Integer then tenant_id = tenant
        when String then tenant_id = tenant.to_i
        else raise ArgumentError
        end
        set_tenant_and_call_listeners tenant_id
      end

      def log_debug(msg)
        tenant_id = current_tenant_id
        log_msg = "HELPER[Tenant: '#{tenant_id}'] #{msg}"
        Rails.logger.info log_msg
        puts log_msg
      end

      private

      def set_tenant_and_call_listeners(tenant_id)
        result = Thread.current[:tenant_id] = tenant_id
        listeners = tenant_listeners
        unless listeners.nil?
          listeners.each do |key, block|
            block.call
          end
        end
        result
      end

      def tenant_listeners
        listeners = Thread.current[:tenant_listeners]
        if listeners.nil?
          listeners = Hash.new
          Thread.current[:tenant_listeners] = listeners
        end
        listeners
      end
    end
  end
end
