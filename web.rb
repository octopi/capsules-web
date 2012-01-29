require 'sinatra'
require 'rubygems'
require 'uri'
require 'mongo'

get '/' do
	erb :index
end

get '/login/:user_id' do
	uri  = URI.parse(ENV['MONGOLAB_URI'])
  	conn = Mongo::Connection.from_uri(ENV['MONGOLAB_URI'])
  	db   = conn.db(uri.path.gsub(/^\//, ''))
  	users_coll = db.collection("users")
  	if users_coll.find("id" => params[:user_id]).length == 0
  		new_user = {"id" => params[:user_id]}
  	end
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