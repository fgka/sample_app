require 'mysql_vpd/tenant_helper'

TENANT_AMOUNT = 2
USER_PER_TENANT = 5
USERS_WITH_MICROPOST_AMOUNT = 2
MICROPOST_AMOUNT = 12

include MysqlVPD::TenantHelper

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_tenants
    make_users
    make_microposts
    make_relationships
  end
end

def make_tenants
  TENANT_AMOUNT.times do |n|
    name = "Tenant-#{n+1}"
    Tenant.create_new_tenant({name: name})
  end
  puts "#{TENANT_AMOUNT} Tenants were created."
end

def make_users
  tenants = Tenant.all
  tenants.each do |tenant|
    Thread.current[:tenant_id] = tenant.id
    admin_name = "Admin User #{tenant.name}"
    admin_email = "admin-#{tenant.name}@railstutorial.org"
    admin_password = "password"
    admin = User.create!(name: admin_name, email: admin_email, password: admin_password, password_confirmation: admin_password)
    admin.toggle!(:admin)
    USER_PER_TENANT.times do |n|
      name = Faker::Name.name
      email = "user-#{tenant.name}-#{n+1}@railstutorial.org"
      password = "password"
      User.create!(name: name, email: email, password: password, password_confirmation: password)
    end
    puts "#{USER_PER_TENANT} Users for tenant #{tenant.name} were created."
  end
end

def make_microposts
  tenants = Tenant.all
  tenants.each do |tenant|
    set_tenant(tenant)
    users = tenant.users(limit: USERS_WITH_MICROPOST_AMOUNT)
    MICROPOST_AMOUNT.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content) }
    end
    puts "#{MICROPOST_AMOUNT} Microposts for #{USERS_WITH_MICROPOST_AMOUNT} users from tenant #{tenant.name} were created."
  end
end

def make_relationships
  tenants = Tenant.all
  tenants.each do |tenant|
    set_tenant(tenant)
    users = tenant.users
    user = users.first
    max_followed = USER_PER_TENANT / 2
    followed_users = users[2..max_followed]
    max_followers = max_followed - USER_PER_TENANT / 10
    followers = users[3..max_followers]
    followed_users.each { |followed| user.follow!(followed) }
    followers.each { |follower| follower.follow!(user) }
    puts "First user from tenant #{tenant.name} follows #{max_followed} users and is followed by #{max_followers} users."
  end
end
