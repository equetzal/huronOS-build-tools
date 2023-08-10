---
sidebar_position: 3
---

# Directives Server

The directives are currently represented as a text file and can be hosted on any web server of your choice, such as nginx, Apache, litespeed, etc. The file must be accessible via HTTP and/or HTTPS protocols and needs to be raw-accessible, without any web UI wrapping the file content.

## Where to host?

- **Public Web Server**  
    If you have access to your own web server with a public IP address, whether it's private or shared, you can upload your directives file and set the proper permissions to make it publicly accessible. This will result in a URL similar to `https://yourdomain.com/some/path/directives.hdf`. Test the URL on huronOS to ensure you can access it!

    > **Note:** If you store your directives file in a shared hosting environment, all websites sharing the same IP address will be accessible from huronOS, as the firewall works at the IP layer.

- **Internet Platforms**  
    Some internet tools like GitHub, Gist, or PasteBin allow you to store simple files, with or without payment. You can use these platforms to store your directives file as long as they provide raw access to the file.

    This method is ideal for personal use or training sessions where you quickly set up a directives file without requiring infrastructure. However, please **be aware** that the firewall will allow access to *all the hosting servers of your website*, which can lead to data leaks (e.g., hosting on GitHub may give contestants access to raw GitHub content and their public repositories).

    GitHub Example:
    `https://raw.githubusercontent.com/equetzal/directives-server/example.hdf`

- **Local Web Server**  
    Another option is to set up a web server (e.g., Apache) on a machine within your local area network. You can access your directives URL using the local IP address or by setting up DHCP with a local DNS proxy to add a registry pointing a fake domain to your local IP address. 
    Examples:
    `http://192.168.1.100/directives.hdf`
    `http://lanserver/directives.hdf`

### Which one to choose?

- For personal use, team training, or local school trainings, using an **internet platform** is the easiest way to host the directives file and responsibly use the system.
- For bigger local events (same lab/school/lan), a **local web server** might be the best option for hosting your directives file. Just be aware that you might need to change the directives file URL if you want to reuse the system elsewhere.
- For official events, such as official contests or training camps, we recommend a **public web server** with a dedicated IP address and a proper domain name with DNS registries configured.

## Tips

- Keep in mind that most *shared hosting* servers use management tools like *cpanel* or *cyberpanel*, and they are usually not configured to be accessed via IP address directly in the URL (e.g., `https://300.300.300.300:443/somefile.hdf`). Therefore, you must use a domain name and DNS resolution to properly access the contents (e.g., `https://yourdomain.com/somefile.hdf`).
- Most *local hosting* servers, such as *apache2*, typically serve without a *domain name*, so you need to set up the URL **with** the IP address (e.g., `http://192.168.1.100/somefile.hdf`).
- If you're setting up a *local hosting* server, then HTTP protocol (without S) is recommended because self-signed HTTPS websites may generate issues on sync.
- You may be able to set up a *local hosting* server and use your router's DNS to set up a custom registry to point a name to your IP (e.g., *lanserver* -> *192.168.1.100*). However, consider that huronOS does not support a persistent */etc/hosts* file to create the local DNS registry.
