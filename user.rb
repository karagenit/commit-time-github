#!/usr/bin/env ruby

require_relative 'commit-time-github'

# TODO: throw error if missing ARGVs
repos = get_all_repos(ARGV[0])

p repos[0]
