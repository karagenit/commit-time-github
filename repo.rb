#!/usr/bin/env ruby

require_relative 'commit-time-github'

# TODO: throw error if missing ARGVs
get_repo(ARGV[0], ARGV[1])
