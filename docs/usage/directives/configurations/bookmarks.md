# Browser Bookmarks
This directive allows for custom bookmarks in Firefox and Chromium. The following syntax is how we can create them:

- `{name^URL}`

This is how it looks in the directives file:
- `Bookmarks={name-1^URL-1}|...|{name-n^URL-n}|`

# Notes
- The URL must contain the http / https prefix, otherwise it would be classified as invalid and the bookmark would not be shown in the browser.

- Given how the bookmarks are applied to the browsers, they are only applied the first time the browsers are opened, thus, it is expected that if an instance already opened chromium and the bookmarks are updated later on in the directives, the bookmarks are going to stay the same in chromium. We plan on improving this so the bookmarks are in sync with the directives file (just give us either more time or more staff ;-;).
