require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

def error_for_list(name)
  if !(1..100).cover?(name.size)
    return 'Whoops! List name must be between 1 and 100 characters.'
  elsif session[:lists].any? { |list| list[:name] == name }
    return 'Whoops! Looks like that list already exists.'
  end
end

def success_for_list(name)
  session[:lists] << { name: name, todos: [] }
  'Boom! That was easy!'
end

configure do
  enable :sessions
  set :session_secret, 'secret'
end

before do
  session[:lists] ||= []
end

# view all the lists
get "/lists" do
  @lists = session[:lists]
  erb :lists, layout: :layout
end

get "/" do
  redirect "/lists"
end

# render a new list form
get "/lists/new" do
  erb :new_list, layout: :layout
end

#create a new list
post "/lists" do
  list_name = params[:list_name].strip
  if error = error_for_list(list_name)
    session[:error] = error
    erb :new_list, layout: :layout
  else success = success_for_list(list_name)
    session[:success] = success
    redirect "/lists"
  end
end
