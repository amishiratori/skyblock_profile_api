require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'sinatra/json'
require 'net/http'


get '/' do
  erb :index
end

get '/show' do
  # input user_name
  user_name = params[:user_name]

  # api keyを代入してね
  api_key = ""

  # player apiにリクエスト飛ばす
  player_api_uri = URI("https://api.hypixel.net/player?key=#{api_key}&name=#{user_name}")
  response = Net::HTTP.get(player_api_uri)
  returned_json = JSON.parse(response)
  # とりあえずskyblockのプロフィール全部arrayに突っ込む
  profile_array = Array.new
  returned_json['player']['stats']['SkyBlock']['profiles'].each do |profile|
    profile_array << profile
  end
  # 一番最初の要素のskyblock profile idだけとれれば十分なので。
  profile_id = profile_array[0].first

  # skyblock profile apiにリクエスト。クエリにさっきのskyblock profile id 持たせる
  sb_profile_uri = URI("https://api.hypixel.net/skyblock/profile?profile=#{profile_id}&key=#{api_key}")
  response = Net::HTTP.get(sb_profile_uri)
  @returned_json = JSON.parse(response)

  # あとはレスポンスをJSONにしてviewにばーん
  erb :show
end