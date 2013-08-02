module ActiveRecord::ConnectionAdapters
  class ConnectionPool

    alias_method :old_checkout, :checkout

    def new_checkout
      conn = old_checkout
      debug "CONN CHECKOUT: after (getting a connection from the pool)"
      debug list_packages(conn)
      #add_tenancy_to_connection conn
      conn
    end

    alias_method :checkout, :new_checkout

    alias_method :old_checkin, :checkin

    def new_checkin(conn)
      debug "CONN CHECKIN: before (releasing a connection back to the pool)"
      #remove_tenancy_from_connection conn
      old_checkin conn
    end

    alias_method :checkin, :new_checkin

    private

    def debug msg
      Rails.logger.info msg
      puts msg
    end

    def get_current_tenant_id
      Thread.current[:tenant_id]
    end

    def add_tenancy_to_connection(conn)
      tenant_id = get_current_tenant_id
      unless conn.nil? || tenant_id.nil?
        debug list_packages(conn)
        debug "CONN adding tenancy for tenant #{tenant_id}"
        add_context conn
        set_tenant conn
      end
    end

    def add_context conn
      sql = 'CREATE OR REPLACE CONTEXT tenant_ctx USING tenant_ctx_pkg'
      conn.execute sql
    end

    def set_tenant conn
      tenant_id = get_current_tenant_id
      sql = "SELECT tenant_ctx_pkg.set_tenant_id(#{tenant_id}) FROM dual"
      cursor = conn.raw_connection.exec sql
      out = cursor.exec
      debug "CONN result of setting tenant_id: #{out}"
      #sql = ActiveRecord::Sanitization.sanitize(["EXECUTE tenant_ctx_pkg.set_tenant_id(%s);", tenant_id])
      #conn.execute sql
    end

    def remove_tenancy_from_connection(conn)
      tenant_id = get_current_tenant_id
      unless conn.nil? || tenant_id.nil?
        debug list_packages(conn)
        debug "CONN removing tenancy for tenant #{tenant_id}"
        unset_tenant conn
        remove_context conn
      end
    end

    def unset_tenant(conn)
      sql = 'BEGIN tenant_ctx_pkg.set_tenant_id(NULL); END'
      conn.execute sql
    end

    def remove_context(conn)
      sql = 'DROP CONTEXT tenant_ctx'
      conn.execute sql
    end

    def list_packages(conn)
      unless conn.nil?
        sql = "SELECT object_name, object_type FROM user_objects WHERE object_type IN ( 'PROCEDURE', 'FUNCTION', 'PACKAGE', 'PACKAGE BODY', 'CONTEXT' )"
        #cursor = conn.execute sql
        cursor = conn.raw_connection.exec sql
        #out = cursor.exec
        out = get_cursor_result cursor
        cursor.close
      end
      debug "CONN LIST OF PACKAGES: #{out}"
    end

    def get_cursor_result(cursor)
      out = " "
      while r = cursor.fetch()
        out += r.join(',')
      end
      out
    end
  end
end

