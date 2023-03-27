# Codeforces Firewall Exception

When firewall is set to `DROP` policy, [Codeforces](https://codeforces.com) is a website that require a lot of exceptions for setting a working website due to the fact that it makes requests to several servers on the internet. Also, allowing codeforces itself will allow contestants to access in-website blogs, editorials, previous user submissions, etc.
Then, it's recommended to setup a [domain for groups](https://codeforces.com/blog/entry/51787) which is a codeforces feature build specifically for running contest with controlled environments.
Using the _domain for groups_ feature, its easy to setup a firewall with only few exceptions. For example:

1. A group for setting a contest has been created on codeforces.
2. Following the [blog instructions](https://codeforces.com/blog/entry/51787), the resulting group domain url is `https://yourgroupdomain.contest.codeforces.com`.
3. Then the firewall needs to make IP exceptions to:

- `yourgroupdomain.contest.codeforces.com` for accessing the platform.
- `assets.codeforces.com` for rendering markdown.

4. Finally, huronOS `AllowedWebsites` rule should be set to:
   `AllowedWebsites=yourgroupdomain.contest.codeforces.com|assets.codeforces.com`
5. Done. This will automate the firewall propagation on the huronOS instances.
