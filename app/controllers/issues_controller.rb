class IssuesController < ApplicationController

  before_filter :require_repo_config

  def index
    @repo_name = session[:repo_name]

    repo = @octokit.repo @repo_name
    @issues = repo.rels[:issues].get.data
  end

end