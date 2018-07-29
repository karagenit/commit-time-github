# Github Commit Time

Run [commit-time](https://github.com/karagenit/commit-time) on Github Repos.

## Setup

To install dependencies:

```
$ bundle install
```

Then, register a [Github OAuth Token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/) and place it in a file called `api.token` in the root of the project directory. Make sure the file **does not** have a newline at the end!

## Usage

For a single repo:

```
$ ./repo OWNER NAME
```

For example:

```
$ ./repo karagenit commit-time
Total: 0 Hours, 58 Minutes
Average: 3 Minutes
Commits: 21
```

For a full user breakdown:

```
$ ./user NAME
```
