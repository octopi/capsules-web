require 'sinatra'
require 'rubygems'
require 'uri'
require 'mongo'

get '/' do
	"Hello world"
  	uri  = URI.parse(ENV['MONGOLAB_URI'])
  	conn = Mongo::Connection.from_uri(ENV['MONGOLAB_URI'])
  	db   = conn.db(uri.path.gsub(/^\//, ''))
  	db.collection_names.each { |name| puts name }
end
