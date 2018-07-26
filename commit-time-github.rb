#!/usr/bin/env ruby

require 'github/graphql'
require 'commit-time'
require 'date'

##
# Returns a CommitTime object from a given Github repo
#
# TODO: paginate
#
def get_repo(user, repo)
  token = File.read('api.token')
  query = File.read('repo.graphql')
  vars = { user: user, repo: repo }

  result = Github.query(token, query, vars)
  
  commits = result["data"]["repository"]["defaultBranchRef"]["target"]["history"]["edges"]
  commits.select! { |e| e["node"]["author"]["user"]["login"] == user }
  dates = commits.map { |e| e["node"]["authoredDate"] }
  dates.map! { |date| DateTime.parse(date) }

  CommitTime.new(dates)
end

def get_user(user)

end
