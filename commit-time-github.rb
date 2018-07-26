#!/usr/bin/env ruby

require 'github/graphql'
require 'commit-time'
require 'date'

def get_repo(user, repo)
  token = File.read('api.token')
  query = File.read('repo.graphql')
  vars = { user: user, repo: repo }

  result = Github.query(token, query, vars)
  
  commits = result["data"]["repository"]["defaultBranchRef"]["target"]["history"]["edges"]
  commits.select! { |e| e["node"]["author"]["user"]["login"] == user }
  dates = commits.map { |e| e["node"]["authoredDate"] }
  dates.map! { |date| DateTime.parse(date) }

  times = CommitTime.new(dates)

  puts "Total: #{(times.total_time / 60).floor} Hours, #{(times.total_time % 60).round} Minutes"
  puts "Average: #{times.average_time.round} Minutes"
  puts "Commits: #{times.commits}"

  # TODO: paginate
end

def get_user(user)

end
