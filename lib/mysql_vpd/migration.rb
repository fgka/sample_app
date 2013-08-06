module MysqlVPD
  module Migration
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
    end

    private

    def drop_function(name)
      execute <<-SQL
      DROP FUNCTION IF EXISTS #{name};
      SQL
    end

    def drop_view(name)
      execute <<-SQL
    DROP VIEW IF EXISTS #{name};
      SQL
    end

    def create_mt_triggers(mt_table, tenant_column, function_name)
      create_before_insert_column_setting_function_based_trigger(mt_table, tenant_column, function_name)
      create_before_update_column_setting_function_based_trigger(mt_table, tenant_column, function_name)
    end

    def create_multitenant_view(view, table, columns, tenant_column, function_name)
      sql = sql_create_multitenant_view(view, table, columns, tenant_column, function_name)
      execute sql
    end

    def sql_create_multitenant_view(view, table, columns, tenant_column, function_name)
      result = "CREATE VIEW #{view} ( "
      result += columns.join(", ")
      result += " ) AS SELECT "
      result += (columns.map { |c| "mt.#{c} AS #{c}" }).join(", ")
      result += " FROM #{table} AS mt WHERE (mt.#{tenant_column} = (SELECT #{function_name}()));"
    end

    def create_before_insert_column_setting_function_based_trigger(table, column, function_name)
      create_before_operation_column_setting_function_based_trigger("INSERT", table, column, function_name)
    end

    def create_before_update_column_setting_function_based_trigger(table, column, function_name)
      create_before_operation_column_setting_function_based_trigger("UPDATE", table, column, function_name)
    end

    def create_before_operation_column_setting_function_based_trigger(operation, table, column, function_name)
      trigger_name = "tr_#{table}_before_#{operation}".downcase
      drop_trigger trigger_name
      sql = get_sql_column_setting_function_based_trigger(trigger_name, operation.upcase, table, column, function_name)
      execute sql
    end

    def drop_trigger(name)
      execute <<-SQL
    DROP TRIGGER IF EXISTS #{name}
    SQL
    end

    def get_sql_column_setting_function_based_trigger(trigger_name, operation, table, column, function_name)
      result = <<-SQL
    CREATE TRIGGER #{trigger_name}
    BEFORE #{operation}
    ON #{table}
    FOR EACH ROW
    BEGIN
      SET NEW.#{column} = (SELECT #{function_name}());
    END
    SQL
    end
  end
end
