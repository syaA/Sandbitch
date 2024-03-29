#!/usr/bin/ruby
# coding: utf-8

require 'rubygems'
require 'sinatra'
require 'active_record'
require 'erb'
require 'securerandom'
require 'json'

ActiveRecord::Base.logger = Logger.new(STDOUT)

db_conf = YAML.load(ERB.new(File.read('./database.yml')).result)
ActiveRecord::Base.establish_connection(db_conf['db']['development'])

class User < ActiveRecord::Base
end
User.connection # これ要る。

def User.find_user(uuid)
  return nil unless uuid =~ /\A[0-9a-fA-F]{32}\Z/
  user = User.where(%Q!uuid=unhex("#{uuid}")!)
  unless user.empty?
    user[0]
  else
    nil
  end
end

Key = ENV['SANDBITCH_DEV_API_KEY']

before do
  content_type :json
end

post '/user' do
  request.body.rewind
  payload = JSON.parse(request.body.read)
  return 403 if payload['key'] != Key
  uuid = SecureRandom.uuid.gsub('-', '').scan(/.{2}/).map{|x| x.to_i(16)}
  User.create(uuid: uuid.pack('C*'))
  {'uuid' => uuid}.to_json
end

get '/user/:uuid/score' do
  user = User.find_user(params[:uuid])
  if user.nil?
    404
  else
    {'score' => user.score}.to_json
  end
end

put '/user/:uuid/score' do
  request.body.rewind
  payload = JSON.parse(request.body.read)
  return 403 if payload['key'] != Key
  user = User.find_user(params[:uuid])
  if user.nil?
    404
  else
    score = payload['score'].to_i
    if user.score < score
      user.update(score: score)
    else
      score = user.score
    end
    {'score' => score}.to_json
  end
end

get '/user/:uuid/ranking' do
  user = User.find_user(params[:uuid])
  if user.nil?
    404
  else
    users = User.order(score: :desc).limit(100)
    ranking = -1
    users.each.with_index { |other, idx|
      if other.id == user.id
        ranking = idx
      end
    }
    {'ranking' => ranking}.to_json
  end
end

put '/user/:uuid/name' do
  request.body.rewind
  payload = JSON.parse(request.body.read)
  return 403 if payload['key'] != Key
  user = User.find_user(params[:uuid])
  if user.nil?
    404
  else
    name = payload['name'].gsub(/[(\r\n?)\\]/, "")[0, 20]
    user.update(name: name)
    {'name' => name}.to_json
  end
end

get '/ranking/:num' do
  num = [params[:num].to_i, 100].min
  users = User.order(score: :desc).limit(num)
  result = []
  users.each { |user|
    result << { 'name' => user.name, 'score' => user.score}
  }
  result.to_json
end

get '/test/randomUser/:num' do
  n = params[:num].to_i
  n.times do
    uuid = SecureRandom.uuid.gsub('-', '').scan(/.{2}/).map{|x| x.to_i(16)}
    User.create(uuid: uuid.pack('C*'), score: rand(5000), name: 'tst_' + rand(n*100000).to_s)
  end
  200
end
