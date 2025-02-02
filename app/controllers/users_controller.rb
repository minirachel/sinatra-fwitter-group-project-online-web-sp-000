require 'rack-flash'

class UsersController < ApplicationController
    enable :sessions
    use Rack::Flash

    get '/users/:slug' do
        @user = User.find_by_slug(params[:slug])
        session[:user_id] = @user.id

        erb :'users/show'
    end

    get '/signup' do
        if Helpers.is_logged_in?(session)
            redirect to '/tweets'
        else
            erb :'users/signup'
        end
    end

    post '/signup' do

        if !User.find_by(:email => params[:email]) && params[:username] != "" && params[:email] != "" && params[:password] != ""
            @user = User.create(params)
            session[:user_id] = @user.id
            redirect to '/tweets'
        else
            redirect to '/signup'
            flash[:message] = "This email is already associated with an account. Please login."
        end
        
    end

    get '/login' do
        if !Helpers.is_logged_in?(session)
            erb :'users/login'
        else 
            redirect to '/tweets'
        end
    end

    post '/login' do
        @user = User.find_by(:username => params[:username])

        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            redirect to '/tweets'
        else
            flash[:message] = "This username or password is incorrect."
            redirect to '/login'
        end
    end

    get '/logout' do
        if Helpers.is_logged_in?(session)
            session.destroy
            redirect to '/login'
        else
            redirect to '/'
        end
    end






end
