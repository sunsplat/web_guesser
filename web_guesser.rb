require 'sinatra'
require 'sinatra/reloader'

get '/' do
	x = rand(100)
  "The SECRET number IS #{x}"
end