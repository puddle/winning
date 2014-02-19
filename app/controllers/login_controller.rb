class LoginController < ApplicationController

  def home
  end

  def github_login
    url = 'https://github.com/login/oauth/authorize?scope=user:email,repo&client_id='
    url << ENV['GITHUB_CLIENT_ID']

    redirect_to url
  end

  def github_callback
    code = params['code']
    fail "NO OAuth CODE!"  if code.nil?

    gh_access_token_path = '/login/oauth/access_token'
    gh_authorize_path = '/login/oauth/authorize'

    client = OAuth2::Client.new( ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET'],
      site: 'https://github.com',
      token_url: gh_access_token_path,
      authorize_path: gh_authorize_path
      )
    token = client.auth_code.get_token(code)
    fail "Failed to get OAuth access token."  if token.nil?

    session[:github_token] = token.token
    redirect_to '/'
  end

  def pick_a_repo
    require_github_session
    @repos = @octokit.user.rels[:repos].get.data
  end

  def pick_repo
    name = params[:repo_name]
    fail "No repo selected!" if name.nil? or name.empty?

    session[:repo_name] = name
    redirect_to '/'
  end
end