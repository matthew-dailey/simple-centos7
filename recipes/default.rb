#
# Cookbook Name:: simple-centos7
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# grab user information from the data bag
user_bag = 'users'
users = data_bag(user_bag)
if users.empty?
  Chef::Application::fatal!("Could not find any users in data_dag #{user_bag}", 1)
end

# check that all public keys are in order as well
public_keys_bag = 'public_keys'
public_keys = data_bag(public_keys_bag)

missing_public_keys = users.select {|username| !public_keys.include?(username) }
if !missing_public_keys.empty?
  Chef::Application::fatal!("Missing public keys for these users: #{missing_public_keys}", 2)
end

sudoer_names = []
users.each do |username|
  # create the user
  user_data = data_bag_item(user_bag, username)
  user username do
    comment user_data['comment']
    uid user_data['uid']
    gid user_data['gid']
    home user_data['home']
    shell user_data['shell']
    password user_data['password_shadow_hash']
  end

  # make .ssh directory
  directory "/home/#{username}/.ssh" do
    owner username
    mode '700'
  end

  # copy in public keys from public_key data_bag
  user_key = data_bag_item(public_keys_bag, username)
  user_public_keys = user_key['public_keys'].join('\n')
  file "/home/#{username}/.ssh/authorized_keys" do
    owner username
    mode '600'
    content user_public_keys
  end

  if user_data['sudoer'] then
    sudoer_names.push(username)
  end
end

# give sudoers sudo
group 'wheel' do
  members sudoer_names
end
