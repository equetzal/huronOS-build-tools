# Setting Firewall for Web Broswing
huronOS includes a firewall that allows to specify which pages would be available, by default all sites are available with `AllowedWebsites=all`, but if you want to specify a site, the syntax is `AllowedWebsites=mysite.com|myotherSite.com|...|`, note that after every site there has to be a pipe `|` to separate them.

# Example
```text
AllowedWebsites=codeforces.com|omegaup.com|
```

# How it works
What the firewall does behind the scenes is to allow the ip of the specified domains, thus, it might not work as expected allowing sites that use dynamic ips because by the time an ip is allowed, the site might use another ip that is blocked.

# Things to keep in mind
Because on how the sites are allowed, some sites might require to allow other sites because they could be using external resources (like fonts or images) that are required for the site to load correctly.