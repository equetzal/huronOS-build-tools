# Expiration Time
The directive file is able to configure when it will expire via `ConfigExpirationTime` configuration once it expires huronOS will use the default directive file. Also it's possible to define that the directive file never expires.

- `ConfigExpirationTime=[never||time]`

To define that the directive file never expires, the value must be set to `never`. Otherwise the value must be set to `time` where `time` it´s the extended format defined by [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601):
- `YYYY-MM-DDTHH:MM:SS`

### Example
An example of a working directive for expiration time is:
```txt
ConfigExpirationTime=2023-05-05T20:00:00
```
