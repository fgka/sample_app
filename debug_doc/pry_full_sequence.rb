# For a full test with pry/console
#  gem install simple-tracer
#  rails console --sandbox
#

trace_file = "#{::Rails.root}/tmp/trace_active_mysql.log"
File.delete(trace_file) if File.exist?(trace_file)
set_trace_func proc { |event, file, line, id, binding, classname|
  if file.include?('active') || file.include?('mysql')
    log_line = "%8s %s:%-2d %10s %8s\n" % [event, file, line, id, classname]
    File.open(trace_file, 'a') { |file| file.write(log_line) }
  end
}

msg = ">>> #{__FILE__}:#{__LINE__} >>> #{}"
puts msg

tenant_a = Tenant.create_new_tenant(name: "Tenant_#{Time.now.to_i}")
Tenant.set_tenant tenant_a
user_a = User.create!(name: "User #{Time.now.to_i}", email: "user.#{Time.now.to_i}@example.com", password: 'password', password_confirmation: 'password')
micropost_a = user_a.microposts.create!(content: "Content #{Time.now.to_i}")

tenant_b = Tenant.create_new_tenant(name: "Tenant_#{Time.now.to_i}")
Tenant.set_tenant tenant_b
user_b = User.create!(name: "User #{Time.now.to_i}", email: "user.#{Time.now.to_i}@example.com", password: 'password', password_confirmation: 'password')
micropost_b = user_b.microposts.create!(content: "Content #{Time.now.to_i}")

Tenant.set_tenant tenant_a

#abstract_mysql_adapter.rb:527 pk_and_sequence_for ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter
def pk(table)
  ActiveRecord::Base.connection.execute_and_free("SHOW CREATE TABLE #{table}", 'SCHEMA') do |result|
    result.each(:as => :hash, :symbolize_keys => true) do |row|
      puts row.to_s
    end
    hash_result = ActiveRecord::Base.connection.each_hash(result)
    create_table = hash_result.first[:"Create Table"]
    create_view = hash_result.first[:"Create View"]
    puts "create_table #{create_table}\ncreate_view #{create_view}\nis empty: #{create_view.to_s.empty?}"
    if create_table.to_s =~ /PRIMARY KEY\s+(?:USING\s+\w+\s+)?\((.+)\)/
      keys = $1.split(",").map { |key| key.gsub(/[`"]/, "") }
      keys.length == 1 ? [keys.first, nil] : nil
    else if !create_view.to_s.empty?
      view_match = create_view.to_s.match(/select.+`(.+)`\.`id` AS `id`.+from `(.*)` `\1` where/).captures
      puts "match: #{view_match.to_s}"
      if view_match.size == 2
        result = pk view_match[1]
        unless result.nil?
          ["id", nil]
        end
      end
    end
  end
end
end

pk "tenants"
pk "microposts"
result = txt.to_s.match(/select.+(`.+`)\.`id` AS `id`.+(from[^,]+) where/i).captures

# Returns an array of +Column+ objects for the table specified by +table_name+.
def cols(table_name, name = nil)#:nodoc:
  sql = "SHOW FULL FIELDS FROM #{ActiveRecord::Base.connection.quote_table_name(table_name)}"
  ActiveRecord::Base.connection.execute_and_free(sql, 'SCHEMA') do |result|
    ActiveRecord::Base.connection.each_hash(result).map do |field|
      puts "#{field[:Field]} : #{field[:Default]} : #{field[:Type]} : #{field[:Null] == "YES"} : #{field[:Collation]}"
    end
  end
end

def create_view_sql_str(table_or_view)
  result = nil
  sql = "SHOW CREATE TABLE #{ActiveRecord::Base.connection.quote_table_name(table_or_view)}"
  ActiveRecord::Base.connection.execute_and_free(sql, 'SCHEMA') do |sql_result|
    create_view_sql = ActiveRecord::Base.connection.each_hash(sql_result).first[1].to_s
    if !create_view_sql.empty?
      result = create_view_sql
      break
    end
  end
  result
end

create_stmt = create_view_sql_str 'owned_books'
create_stmt_with_join = 'CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `owned_books` AS select `t`.`id` AS `id`,`b`.`title` AS `title`,`b`.`author` AS `author`,`b`.`cover` AS `cover`,`b`.`description` AS `descrition` from (`books` `b` join `tenants` `t`)$$'
create_stmt_without_join = 'CREATE ALGORITHM=UNDEFINED DEFINER=`rubydev`@`localhost` SQL SECURITY DEFINER VIEW `microposts` AS select `mt`.`id` AS `id`,`mt`.`content` AS `content`,`mt`.`user_id` AS `user_id`,`mt`.`created_at` AS `created_at`,`mt`.`updated_at` AS `updated_at` from `mt_microposts` `mt` where (`mt`.`tenant_id` = (select `get_ctx_tenant`()))$$'

def single_table_view? (create_stmt)
  result = false
  match_create_algorithm = create_stmt.match(/CREATE ALGORITHM.+from(.+)/i)
  if !match_create_algorithm.nil?
    from_part = match_create_algorithm.captures[0].split(/where.*/i)[0]
    result = !from_part.downcase.include?('join')
  end
  result
end

single_table_view? create_stmt_with_join # false
single_table_view? create_stmt_without_join # true


def actual_table_and_alias(create_view_stmt)
  from_match = create_view_stmt.match(/FROM[[:blank:]].(.*).[[:blank:]]WHERE/i)
  result = from_match.captures[0].split(/`[[:space:]]+`/)
  if result.size == 0 || result.size > 2
    fail
  end
  if result.size == 1
    result[1] = result[0]
  end
  result
end

create_stmt_without_alias = 'CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `owned_books` AS select `books`.`title` AS `title`,`books`.`author` AS `author`,`books`.`cover` AS `cover`,`books`.`description` AS `descrition` from `books` where (`books`.`owner` = (select `get_ctx_tenant`()))$$'

actual_table_and_alias create_stmt_without_alias # ["books", "books"]
actual_table_and_alias create_stmt_without_join # ["mt_microposts", "mt"]

cols "tenants"
cols "microposts"

single_table_view? "tenants" # false
single_table_view? "microposts" # true

