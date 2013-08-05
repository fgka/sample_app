module MysqlVPD
  module Control
    class InvalidTenantAccess < SecurityError; end

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
    end

    private
    def set_current_tenant( tenant_id = nil )
      if user_signed_in?

        @_my_tenants ||= current_user.tenants  # gets all possible tenants for user

        tenant_id ||= session[:tenant_id]   # use session tenant_id ?

        if tenant_id.nil?  # no arg; find automatically based on user
          tenant_id = @_my_tenants.first.id  # just pick the first one
        else   # validate the specified tenant_id before setup
          raise InvalidTenantAccess unless @_my_tenants.any?{|tu| tu.id == tenant_id}
        end

        session[:tenant_id] = tenant_id  # remember it going forward

      else   # user not signed in yet...
        tenant_id = 0  if tenant_id.nil?   # an impossible tenant_id
      end

      Thread.current[:tenant_id] = tenant_id
      true    # before filter ok to proceed
    end

    def initiate_tenant(tenant)
      Thread.current[:tenant_id] = tenant.id
    end
  end
end
