module ActiveRecord::ConnectionAdapters
  class ConnectionPool

    alias_method :old_checkout, :checkout

    def new_checkout
      conn = old_checkout
      msg = "CONN CHECKOUT: after"
      Rails.logger.info msg
      puts msg

      conn
    end

    alias_method :checkout, :new_checkout

    alias_method :old_checkin, :checkin

    def new_checkin(conn)
      msg = "CONN CHECKIN: before"
      Rails.logger.info msg
      puts msg

      old_checkin conn
    end

    alias_method :checkin, :new_checkin
  end
end

