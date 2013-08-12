module ActiveRecord
  module ConnectionAdapters
    class AbstractMysqlAdapter

      alias_method :old_pk_and_sequence_for, :pk_and_sequence_for

        def new_pk_and_sequence_for(table)
          result = old_pk_and_sequence_for table
          if result.nil?
            result = pk_and_sequence_for_view table
          end
          puts "result #{table}: #{result.to_s}"
          result
        end

      alias_method :pk_and_sequence_for, :new_pk_and_sequence_for

        private

      def pk_and_sequence_for_view(view)
        result = nil
        execute_and_free("SHOW CREATE TABLE #{quote_table_name(view)}", 'SCHEMA') do |exec_result|
          create_view = each_hash(exec_result).first[:"Create View"]
          unless create_view.to_s.empty?
            view_match = create_view.to_s.match(/select.+`(.+)`\.`id` AS `id`.+from `(.*)` `\1` where/).captures
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
    end
  end
end
