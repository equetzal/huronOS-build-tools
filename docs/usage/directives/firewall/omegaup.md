# OmegaUP Firewall Exception

To set up the huronOS firewall to open the web connectivity with the OmegaUP platform, it is required to open several websites for OmegaUP to work correctly. OmegaUP does not have a feature to isolate your contest from the rest of the platform as Codeforces does, so, beware as allowing this platform will let the users to also access their private files, such as previous submissions.

Please, use the following rules on your `AllowedWebsites` configuration:
```ini title="directives.hdf"
AllowedWebsites=omegaup.com|maxcdn.bootstrapcdn.com|samhebert.net|cdnjs.cloudflare.com
```

This will also enable OmegaUP's ephemeral grader feature.

If you find out some missing exceptions, please open a Pull Request on the [huronOS-build-tools](https://github.com/equetzal/huronOS-build-tools) repository.