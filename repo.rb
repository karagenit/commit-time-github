#!/usr/bin/env ruby

require_relative 'commit-time-github'

# TODO: throw error if missing ARGVs
# TODO: allow different owner/author... maybe parse e.g. "karagenit/commit-time"?
times = get_repo(ARGV[0], ARGV[1])

puts "Total: #{(times.total_time / 60).floor} Hours, #{(times.total_time % 60).round} Minutes"
puts "Average: #{times.average_time.round} Minutes"
puts "Commits: #{times.commits}"
