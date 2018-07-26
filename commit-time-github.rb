#!/usr/bin/env ruby

require 'github/graphql'
require 'commit-time'
require 'date'

##
# Returns a CommitTime object from a given Github repo.
# Commits are filtered such that only those authored by :author (which is,
# by default, equal to :user) are saved. Passing "" for :author will *jankily*
# calculate times for all users.
#
# TODO: paginate
# TODO: rename user -> owner
#
def get_repo(user, repo, author: user)
  token = File.read('api.token')
  query = File.read('repo.graphql')
  vars = { user: user, repo: repo }

  result = Github.query(token, query, vars)
  
  commits = result["data"]["repository"]["defaultBranchRef"]["target"]["history"]["edges"]
  commits.select! { |e| e["node"]["author"]["user"]["login"] == author }
  dates = commits.map { |e| e["node"]["authoredDate"] }
  dates.map! { |date| DateTime.parse(date) }

  CommitTime.new(dates)
end

##
# TODO: paginate
#
def get_repo_list(user)
  token = File.read('api.token')
  query = File.read('user.graphql')
  vars = { user: user }

  result = Github.query(token, query, vars)

  repos = result["data"]["user"]["repositories"]["edges"]
  repos.map { |e| { owner: e["node"]["owner"]["login"], name: e["node"]["name"] } }
end

def get_all_repos(user)
end
