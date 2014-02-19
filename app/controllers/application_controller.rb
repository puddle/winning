class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def setup_octokit_client
    token = session[:github_token]
    fail "You don't have an active GitHub token"  if token.nil?

    @octokit = Octokit::Client.new :access_token => token
    @octokit.user.login
  end

  def require_github_session
    return redirect_to login_url  if session[:github_token].nil?
    setup_octokit_client

    false
  end

  def require_repo_config
    val = require_github_session  
    return val  if val
    return redirect_to pick_a_repo_url  if session[:repo_name].nil?
  end
end
