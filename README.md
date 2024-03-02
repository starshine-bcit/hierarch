# hierarch


## mailcow configuration

It is necessary to login and and change the admin password manually.
The default username is `admin` and the password is `moohoo`.
After doing so, follow the below instructions to get keycloak configured
as an identity provider for mailcow. Note that keycloak will already be
configured in this way, you just need to do the mailcow part.

https://mailcow.email/posts/2023/mailcow-idp/

## Credits

Thanks to all contributers who of the roles/collections in the `requirements.yml`.

Special thanks to [enough](https://lab.enough.community/main/infrastructure) and [ansible-middleware](https://github.com/ansible-middleware/keycloak), as some of the roles here are based on their work.

## License

AGPLv3.0 or later