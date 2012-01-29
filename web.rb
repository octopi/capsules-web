require 'sinatra'
require 'rubygems'
require 'uri'
require 'mongo'

get '/' do
	erb :index
end

post '/login' do
	uri  = URI.parse(ENV['MONGOLAB_URI'])
  	conn = Mongo::Connection.from_uri(ENV['MONGOLAB_URI'])
  	db   = conn.db(uri.path.gsub(/^\//, ''))
  	users_coll = db.collection("users")
  	if users_coll.count(:query => {"id" => params[:user_id]}) == 0
  		new_user = {"id" => params[:user_id]}
  		users_coll.insert(new_user)
  		"inserted new user"
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