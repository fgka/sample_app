module OracleVPD
  module ConnectionPoolVPD
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
    end

    module InstanceMethods
      old_checkout = ActiveRecord::ConnectionAdapters::ConnectionPool.instance_method(:checkout)

      def new_checkout
        msg = "CONN OK, worked"
        Rails.logger.info msg
        puts msg
        old_checkout.bind(self).call
      end
    end
  end
end

