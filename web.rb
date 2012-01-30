require 'sinatra'
require 'rubygems'
require 'uri'
require 'mongo'

enable :sessions

get '/' do
	erb :index
end

post '/login' do
	uri  = URI.parse(ENV['MONGOLAB_URI'])
  	conn = Mongo::Connection.from_uri(ENV['MONGOLAB_URI'])
  	db   = conn.db(uri.path.gsub(/^\//, ''))
  	users_coll = db.collection("users")
  	if users_coll.count(:query => {"fbid" => params[:user_id]}) == 0
  		new_user = {"fbid" => params[:user_id]}
  		users_coll.insert(new_user)
  		"inserted new user"
  	end
  	user = users_coll.find({"fbid" => params[:user_id]}).first
  	"b "+user['_id'].to_s
  	sessions['ocid'] = user['_id'].to_s
  	redirect '/me'
end

get '/me' do
	erb :me
end

post '/new_capsule' do
	uri  = URI.parse(ENV['MONGOLAB_URI'])
  	conn = Mongo::Connection.from_uri(ENV['MONGOLAB_URI'])
  	db   = conn.db(uri.path.gsub(/^\//, ''))
  	capsules = db.collection("capsules")
  	new_capsule = {"strKey" => params[:strKey].strip!, "friends" => params[:friends]}
  	capsules.insert(new_capsule);
end

#uri  = URI.parse(ENV['MONGOLAB_URI'])
  	#conn = Mongo::Connection.from_uri(ENV['MONGOLAB_URI'])
  	#db   = conn.db(uri.path.gsub(/^\//, ''))
  	#users_coll = db.collection("users")
  	##test = {"name" => "David", "id" => 123123123}
  	#users_coll.insert(test)

  	#users_coll.find().each { |row|
  #		puts row.inspect
  #	}