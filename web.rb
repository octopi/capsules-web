require 'sinatra'
require 'rubygems'
require 'uri'
require 'mongo'
require 'json'
require 'foursquare2'

enable :sessions

get '/' do
	erb :index
end

post '/login' do
	uri  = URI.parse(ENV['MONGOLAB_URI'])
  	conn = Mongo::Connection.from_uri(ENV['MONGOLAB_URI'])
  	db   = conn.db(uri.path.gsub(/^\//, ''))
  	# users_coll = db.collection("users")
  	# if users_coll.count(:query => {"fbid" => params[:user_id]}) == 0
  	# 	new_user = {"fbid" => params[:user_id], "name" => params[:name]}
  	# 	users_coll.insert(new_user)
  	# 	"inserted new user"
  	# end
  	# user = users_coll.find({"fbid" => params[:user_id]}).first
  	# "b "+user['_id'].to_s
  	# session['ocid'] = user['_id'].to_s
  	# redirect '/me'
end

get '/login' do
	erb :login
end

post '/home' do
	fsq_token = params[:access_token]
	client = Foursquare2::Client.new(:oauth_token => fsq_token)
	user = client.user('self')

	@name = user.firstName+' '+user.lastName
	fsqid = user.id

	# add to db if user doesn't exist
	uri  = URI.parse(ENV['MONGOLAB_URI'])
  	conn = Mongo::Connection.from_uri(ENV['MONGOLAB_URI'])
  	db   = conn.db(uri.path.gsub(/^\//, ''))
  	users_coll = db.collection("users")
  	if users_coll.count(:query => {"fsqid" => fsqid}) == 0
  		new_user = {"fsqid" => fsqid, "name" => @name}
  		users_coll.insert(new_user)
  		@new_user = "inserted new user"
  	end
  	user = users_coll.find({"fbid" => params[:user_id]}).first
  	session['ocid'] = user['_id'].to_s

	erb :home
end

get '/me' do
	erb :me
end

post '/new_capsule' do
	uri  = URI.parse(ENV['MONGOLAB_URI'])
  	conn = Mongo::Connection.from_uri(ENV['MONGOLAB_URI'])
  	db   = conn.db(uri.path.gsub(/^\//, ''))
  	capsules = db.collection("capsules")
  	new_capsule = {"strKey" => params[:strKey].strip!, "members" => eval(params[:members].gsub(/\:/, "=>")), "fileList" => eval(params[:fileList].gsub(/\:/, "=>")), "creator" => params[:creator]}
  	capsules.insert(new_capsule);
end

get '/get_capsules/:fsqid' do
	content_type :json
	uri  = URI.parse(ENV['MONGOLAB_URI'])
  	conn = Mongo::Connection.from_uri(ENV['MONGOLAB_URI'])
  	db   = conn.db(uri.path.gsub(/^\//, ''))
  	capsules_coll = db.collection("capsules")

  	capsules_list = {}
  	i = 0
  	capsules_coll.find().each { |capsule|
      if capsule['creator'] == params[:fsqid].to_s
        capsules_list[i] = capsule
        i = i+1
      end
  	}
  	capsules_list.to_json
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
