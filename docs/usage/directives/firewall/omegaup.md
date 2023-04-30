# OmegaUP Firewall Exception

For setting up the huronOS firewall to open the web connectivity with the OmegaUP platform, is required to open several websites for OmagaUP to work correctly. OmegaUP does not have a feature to isolate your contest from the rest of the platform as codeforces does, so, be aware that allowing this platform will allow the users to also access their private file such as previous submissions.

Please, use the following rules on your `AllowedWebsites` configuration:
`AllowedWebsites=omegaup.com|maxcdn.bootstrapcdn.com|samhebert.net|cdnjs.cloudflare.com`

This will also enable OmegaUP's ephemeral grader feature.

If you find out some missing exception, please open a Pull Request on the [huronOS-build-tools](https://github.com/equetzal/huronOS-build-tools) repository.