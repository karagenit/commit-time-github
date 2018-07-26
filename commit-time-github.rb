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
# TODO: use :dig more
#
def get_repo(user, repo, author: user)
  token = File.read('api.token')
  query = File.read('repo.graphql')
  vars = { user: user, repo: repo }

  result = Github.query(token, query, vars)
  
  commits = result.dig("data", "repository", "defaultBranchRef", "target", "history", "edges")

  # Empty repo with no commits or default branch
  return nil if commits.nil?

  commits.select! { |e| e.dig("node", "author", "user", "login") == author }
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
  values = get_repo_list(user).map do |repo|
    owner = repo[:owner]
    name = repo[:name]
    { name: "#{owner}/#{name}", times: get_repo(owner, name, author: user) }
  end

  # Remove entries where get_repo returned nil i.e. there was an issue with it
  values.select { |val| !val[:times].nil? }
end
