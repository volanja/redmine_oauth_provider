require 'oauth/controllers/provider_controller'
class OauthController < ApplicationController
  unloadable
  skip_filter :check_if_login_required
  include OAuth::Controllers::ProviderController

  before_filter :login_or_oauth_required, :only => [:user_info]

  def logged_in?
    User.current.logged?
  end

  def login_required
    raise Unauthorized unless User.current.logged?
  end

  def user_info
    respond_to do |format|
      format.json { render :json => User.find(session[:user_id]) }
    end
  end

  def current_user
    User.find(session[:user_id])
  end

  def current_user=(user)
    start_user_session(user)
  end

  def authorize_with_allow
    params[:authorize] = '1' if params[:allow]
    authorize_without_allow
  end
  alias_method_chain :authorize, :allow

  protected
  # Override this to match your authorization page form
  # It currently expects a checkbox called authorize
  # def user_authorizes_token?
  #   params[:authorize] == '1'
  # end

  # should authenticate and return a user if valid password.
  # This example should work with most Authlogic or Devise. Uncomment it
  # def authenticate_user(username,password)
  #   user = User.find_by_email params[:username]
  #   if user && user.valid_password?(params[:password])
  #     user
  #   else
  #     nil
  #   end
  # end

end
