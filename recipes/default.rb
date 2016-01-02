#
# Cookbook Name:: simple-centos7
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# grab user information from the data bag
user_bag = 'users'
users = search(user_bag, "*:*")
if users.empty? then
  Chef::Application::fatal!("Could not find any users in data_dag #{user_bag}", 1)
end

users.each do |user_data|
  user user_data['id'] do
    comment user_data['comment']
    uid user_data['uid']
    gid user_data['gid']
    home user_data['home']
    shell user_data['shell']
    password user_data['password_shadow_hash']
  end
end

sudoer_names = users.select {|user| user['sudoer'] == true }.collect {|user| user['id']}
group 'wheel' do
  members sudoer_names
end
