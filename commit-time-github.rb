#!/usr/bin/env ruby

require 'github/graphql'
require 'commit-time'

def get_repo(user, repo)
  token = File.read('api.token')
  query = File.read('repo.graphql')
  vars = { user: user, repo: repo }

  result = Github.query(token, query, vars)
  
  commits = result["data"]["repository"]["defaultBranchRef"]["target"]["history"]["edges"]
  commits.select! { |e| e["node"]["author"]["user"]["login"] == user }
  commits.map! { |e| e["node"]["authoredDate"] }

  p commits

  # TODO: paginate
end

def get_user(user)

end
