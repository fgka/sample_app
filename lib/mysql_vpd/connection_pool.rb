module ActiveRecord::ConnectionAdapters
  class ConnectionPool

    include MysqlVPD::TenantHelper

    alias_method :old_checkout, :checkout

    def new_checkout
      conn = old_checkout
      set_tenant_listener_lambda(conn)
      set_connection_tenant conn
      conn
    end

    alias_method :checkout, :new_checkout

    alias_method :old_checkin, :checkin

    def new_checkin(conn)
      unset_tenant_listener_lambda conn
      old_checkin conn
    end

    alias_method :checkin, :new_checkin

    private

    def set_tenant_listener_lambda(conn)
      listeners = Thread.current[:tenant_listeners]
      if listeners.nil?
        listeners = Hash.new
        Thread.current[:tenant_listeners] = listeners
      end
      listeners[:connection_pool] = lambda { set_connection_tenant(conn) }
    end

    def unset_tenant_listener_lambda(conn)
      listeners = Thread.current[:tenant_listeners]
      unless listeners.nil?
        Thread.current[:tenant_listeners].delete(:connection_pool)
      end
    end

    def set_connection_tenant conn
      tenant_id = current_tenant_id
      unless tenant_id.is_a? Numeric
        tenant_id = "NULL"
      end
      send_tenant_id(conn, tenant_id)
    end

    def send_tenant_id(conn, tenant_id)
      sql = "SELECT @tenant_id := #{tenant_id};"
      conn.execute sql
    end
  end
end

