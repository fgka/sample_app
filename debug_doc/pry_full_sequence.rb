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

result = txt.to_s.match(/select.+(`.+`)\.`id` AS `id`.+(from[^,]+) where/).captures
