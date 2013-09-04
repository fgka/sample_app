module MysqlVPD
  module Control
    class InvalidTenantAccess < SecurityError; end

    def self.included(base)
      base.send :extend, ClassMethods
    end

    private

    def set_current_tenant(tenant_id = nil)
      if user_signed_in?
        @_my_tenants ||= current_user.tenants
        tenant_id ||= session[:tenant_id]
        if tenant_id.nil?
          tenant_id = @_my_tenants.first.id
        else
          raise InvalidTenantAccess unless @_my_tenants.any?{|tu| tu.id == tenant_id}
        end
        session[:tenant_id] = tenant_id
      else
        tenant_id = 0 if tenant_id.nil?
      end
      set_tenant tenant_id
      true
    end

    def initiate_tenant(tenant)
      set_tenant tenant.id
    end

    module ClassMethods
    end
  end
end
