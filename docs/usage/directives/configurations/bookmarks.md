# Browser Bookmarks
This directive allows for custom bookmarks in Firefox and Chromium. The following syntax is how we can create them:

- `{BookmarkTitle^URL}`

This is how it looks in the directives file:
- `Bookmarks={BookmarkTitle^URL}|...|{BookmarkTitle^URL}|`

# Notes
- The URL MUST CONTAIN the http(s):// prefix, otherwise it would be classified as invalid and the bookmark would not be added to the browsers.
- We have an extension that comes preinstalled with the browsers, this allows you to see a bookmark reflected in every huronOS instance at most 2 minutes after pushing the changes to the bookmarks directive rule.