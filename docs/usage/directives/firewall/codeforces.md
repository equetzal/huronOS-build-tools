# Codeforces Firewall Exception

When the firewall is blocking all the internet connectivity, setting an exception to [Codeforces](https://codeforces.com) would require many exceptions for getting the site to work properly due to the fact that it makes requests to several servers on the internet. Also, allowing Codeforces itself will allow contestants to access in-website blogs, editorials, previous user submissions, etc.

Then, it's recommended to setup a [*domain for groups*](https://codeforces.com/blog/entry/51787) which is a Codeforces feature built specifically for running contests with controlled environments.
Using the _domain for groups_ feature, grants an easy firewall setup with only few exceptions. For example:

1. A group for setting a contest has been created on Codeforces.
2. Following the [blog instructions](https://codeforces.com/blog/entry/51787), the resulting group domain url is `https://yourgroupdomain.contest.codeforces.com`.
3. Then the firewall needs to make IP exceptions to:

- `yourgroupdomain.contest.codeforces.com` for accessing the platform.
- `assets.codeforces.com` for rendering markdown.

4. Finally, huronOS `AllowedWebsites` rule should be set to:
   ```ini title="directives.hdf"
   AllowedWebsites=yourgroupdomain.contest.codeforces.com|assets.codeforces.com
   ```
5. Done. This will automate the firewall propagation to the huronOS instances.
