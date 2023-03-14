#!/bin/bash
for file in *.json
do
  cat $file | jq '{
  rows: [.data.children[].data | {
    id,
    subreddit,
    title,
    url,
    ups,
    num_comments,
    created_utc: (.created_utc | todateiso8601),
    subreddit_subscribers,
    domain,
    permalink: ("https://www.reddit.com" + .permalink)
  }],
  replace: true
}' | \
  curl -X POST -H "Content-Type: application/json" \
    -H "Authorization: Bearer $DS_TOKEN" \
    -d @- https://simon.datasette.cloud/data/reddit_posts/-/insert
done
