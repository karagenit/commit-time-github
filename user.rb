#!/usr/bin/env ruby

require_relative 'commit-time-github'

# TODO: throw error if missing ARGVs
repos = get_all_repos(File.read('api.token'), ARGV[0])

# TODO: display progress info for queries

repos.each do |repo|
  name = repo[:name]
  times = repo[:times]

  # TODO: format into columns
  puts "#{name}: #{(times.total_time / 60).floor} Hours, #{(times.total_time % 60).round} Minutes"
end
