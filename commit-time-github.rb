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
def get_repo(token, user, repo, author: user)
  query = File.read(__dir__ + '/repo.graphql')
  vars = { user: user, repo: repo }

  commits = []
  continue = true
  cursor = nil

  while continue do
    vars[:cursor] = cursor
    result = Github.query(token, query, vars)
    commits += result.dig("data", "repository", "defaultBranchRef", "target", "history", "edges").to_a
    continue = result.dig("data", "repository", "defaultBranchRef", "target", "history", "pageInfo", "hasNextPage") || false
    cursor = result.dig("data", "repository", "defaultBranchRef", "target", "history", "pageInfo", "endCursor")
  end

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
def get_repo_list(token, user)
  query = File.read(__dir__ + '/user.graphql')
  vars = { user: user }

  result = Github.query(token, query, vars)

  # TODO: handle errors better here?
  repos = result.dig("data", "user", "repositories", "edges") || [] # empty array if nil
  repos.map { |e| { owner: e["node"]["owner"]["login"], name: e["node"]["name"] } }
end

def get_all_repos(token, user)
  values = get_repo_list(token, user).map do |repo|
    owner = repo[:owner]
    name = repo[:name]
    { name: "#{owner}/#{name}", times: get_repo(token, owner, name, author: user) }
  end

  # Remove entries where get_repo returned nil i.e. there was an issue with it
  values.select { |val| !val[:times].nil? }
end
