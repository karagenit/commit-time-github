#!/usr/bin/env ruby

require_relative 'commit-time-github'

# TODO: throw error if missing ARGVs
repos = get_repo_list(ARGV[0])
