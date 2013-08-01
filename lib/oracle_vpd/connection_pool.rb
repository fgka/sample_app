module ActiveRecord::ConnectionAdapters
  class ConnectionPool

    alias_method :old_checkout, :checkout
    def new_checkout
      msg = "CONN OK, worked"
      Rails.logger.info msg
      puts msg
      old_checkout
    end
  end
end

