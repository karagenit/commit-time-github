#!/usr/bin/env ruby

require 'github/graphql'
require 'commit-time'

def get_repo(user, repo)
  token = File.read('api.token')
  query = File.read('repo.graphql')
  vars = { user: user, repo: repo }

  data = Github.query(token, query, vars)

  p data

  # TODO: paginate
end

def get_user(user)

end
