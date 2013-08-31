module ActiveRecord
  module ConnectionAdapters
    class AbstractMysqlAdapter

      alias_method :old_pk_and_sequence_for, :pk_and_sequence_for

        def new_pk_and_sequence_for(table_or_view)
          result = nil
          if single_table_view? table_or_view
            result = pk_and_sequence_for_view(table_or_view)
          else
            result = old_pk_and_sequence_for(table_or_view)
          end
          result
        end

      alias_method :pk_and_sequence_for, :new_pk_and_sequence_for

        alias_method :old_columns, :columns

      def new_columns(table_name, name = nil)
        result = nil
        if single_table_view?(table_name)
          result = columns_for_view(table_name)
          #result = old_columns(table_name, name)
        else
          result = old_columns(table_name, name)
        end
        result
      end

      alias_method :columns, :new_columns

      private

      def single_table_view?(table_or_view)
        create_view_stmt = create_view_sql_stmt(table_or_view)
        result = is_create_view_stmt_single_table?(create_view_stmt)
      end

      def create_view_sql_stmt(table_or_view)
        result = nil
        sql = "SHOW CREATE TABLE #{quote_table_name(table_or_view)}"
        execute_and_free(sql, 'SCHEMA') do |sql_result|
          create_view_sql = each_hash(sql_result).first[:"Create View"].to_s
          unless create_view_sql.empty?
            result = create_view_sql
            break
          end
        end
        result
      end

      def is_create_view_stmt_single_table?(create_view_stmt)
        result = false
        unless create_view_stmt.nil?
          match_create_algorithm = create_view_stmt.match(/CREATE ALGORITHM.+FROM(.+)/i)
          unless match_create_algorithm.nil?
            from_part = match_create_algorithm.captures[0].split(/WHERE.*/i)[0]
            result = !from_part.upcase.include?('JOIN')
          end
        end
        result
      end

      def pk_and_sequence_for_view(view)
        result = nil
        execute_and_free("SHOW CREATE TABLE #{quote_table_name(view)}", 'SCHEMA') do |exec_result|
          create_view = each_hash(exec_result).first[:"Create View"]
          unless create_view.to_s.empty?
            view_match = create_view.to_s.match(/SELECT.+`(.+)`\.`id` AS `id`.+FROM `(.*)` `\1` WHERE/i).captures
            if view_match.size == 2
              original_table = view_match[1]
              table_res = old_pk_and_sequence_for original_table
              unless table_res.nil?
                result = ["id", nil]
              end
            end
          end
        end
        result
      end

      def columns_for_view(view)
        create_view_stmt = create_view_sql_stmt(view)
        alias_to_table = actual_table_map_alias_to_table(create_view_stmt)
        table = alias_to_table.first[1]
        view_cols_to_table_cols_map = view_column_to_table_column_map(create_view_stmt, alias_to_table)
        field_hash_for_view = field_hash_from_table_or_view(view)
        field_hash_for_table = field_hash_from_table_or_view(table)
        add_columns_for_view_using_table_definition(field_hash_for_view, field_hash_for_table, view_cols_to_table_cols_map)
      end

      def actual_table_map_alias_to_table(create_view_stmt)
        result = {}
        from_match = create_view_stmt.match(/FROM[[:blank:]].(.*).[[:blank:]]WHERE/i)
        table_and_alias = from_match.captures[0].split(/`[[:space:]]+`/)
        if table_and_alias.size == 0 || table_and_alias.size > 2
          fail
        end
        if table_and_alias.size == 1
          table_and_alias[1] = table_and_alias[0]
        end
        result[table_and_alias[1]] = table_and_alias[0]
        result
      end

      def view_column_to_table_column_map(create_view_stmt, alias_to_table)
        result = {}
        columns_match = create_view_stmt.match(/SELECT[[:space:]]+(.+)[[:space:]]+FROM/i)
        alias_col_and_view_col_arr = columns_match.captures[0].gsub('`', '').split(',')
        alias_col_and_view_col_arr.each do |alias_col_view_col|
          alias_col_and_view_col = alias_col_view_col.split(/[[:space:]]+AS[[:space:]]+/i)
          alias_and_col = alias_col_and_view_col[0].split('.')
          t_col = alias_and_col[1]
          if alias_and_col.size != 2
            view_name = view_name_from_create_stmt(create_view_stmt)
            Rails.log.warn "View column is not mapped to a table column, ignoring view column #{t_col.upcase} from view #{view_name}"
          else
            t_alias = alias_and_col[0]
            v_col = alias_col_and_view_col[1]
            if alias_to_table[t_alias].nil?
              fail
            end
            result[v_col] = t_col
          end
        end
        result
      end

      def view_name_from_create_stmt(create_view_stmt)
        result = create_view_stmt.match(/VIEW[[:space:]]+`(.*)`[[:space:]]+AS[[:space:]]SELECT/i).captures[0]
      end

      def field_hash_from_table_or_view(table_or_view)
        result = {}
        sql = "SHOW FULL FIELDS FROM #{quote_table_name(table_or_view)}"
        execute_and_free(sql, 'SCHEMA') do |sql_result|
          each_hash(sql_result).map do |field|
            result[field[:Field]] = field
          end
        end
        result
      end

      def add_columns_for_view_using_table_definition(field_hash_for_view, field_hash_for_table, view_cols_to_table_cols_map)
        result = []
        field_hash_for_view.each do |v_col, v_field|
          t_col = view_cols_to_table_cols_map[v_col]
          if t_col.nil?
            field = v_field
          else
            field = field_hash_for_table[t_col]
          end
          col = add_new_column(v_col, field)
          result.push(col)
        end
        result
      end

      def add_new_column(col_name, field)
        #f_name = field[:Field]
        f_name = col_name
        f_default = field[:Default]
        f_type = field[:Type]
        f_null = field[:Null] == "YES"
        f_collation = field[:Collation]
        new_column(f_name, f_default, f_type, f_null, f_collation)
      end

    end
  end
end
