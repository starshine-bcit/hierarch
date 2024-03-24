# hierarch

Proof of concept open-source enterprise tech stack, implemented with ansible.

## Overview

Do we really need Google, Microsoft, etc., for a small tech-oriented business? Hierarch was imagined as a replacement for a proprietary technology stack that many organizations run. A small IT team could manage Hierarch for a small organization and maintain a reasonable level of compliance & security.

This repository, and associated submodule, are not production ready. It is designed as a POC that could be customized to meet the needs of a given organization. The system, as a whole, is designed to be compatible with both cloud and on-prem deployments.

The POC is composed of three servers. Debian 12 (bookworm) is the only supported distribution at time of writing.

### Admin

The so-called admin server is an identity provider, hosting Keycloak. It also contains the primary Postgres database, which a variety of other services use.

This server, in it's current configuration, is also responsible for hosting and mirroring the automated backups from the other servers. The backups are designed in this fashion:

1. Each server has it's own Borg archive on the backup (admin) server, which it write to daily. An arbitrary number of daily, weekly, and monthly backups are retained.
2. Daily, the backup server mirrors an encrypted tgz of each archive to some cloud provider.
3. Weekly, it is intended that someone rsyncs each borg archive to a rotating external drive, which should be stored in a secure location.

Finally, the admin server hosts a dashboard which is meant to act as a homepage for users, making it easier to access the various services.

Spec for POC:

- 2 Ryzen 9 vcore
- 6 GB RAM + 1 GB swap
- 80 GB SSD

### Mail

The mail server is dedicated to running an instance of Mailcow: Dockerized. This is due to the high RAM requirement.

Spec for POC:

- 2 Ryzen 9 vcore
- 6 GB RAM + 1 GB Swap
- 80 GB SSD

### App

The app server hosts all the other services which are part of Hierarch. Services either run with docker or natively. They are:

- Forgejo
- Forgejo Runner
- Matrix Synapse
- Element Webapp
- Cryptpad
- Wiki.js
- Frappe HRMS
- Aurora files

Spec for POC:

- 8 Epyc Milan vcore
- 16 GB RAM
- 160 GB SSD

## How to do?

First clone the repository, including the `--recurse-submodule` flag. This tells git to checkout the submodule, which is an ansible collection that contains a number of roles required for Hierarch.

In order to run the configuration, you will need to have a modern Linux system with a full Ansible installation. The [documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#pipx-install) has a guide on how to install it with pipx (recommended).

After installing Ansible, then run `ansible-galaxy install -r requirements.yml` in the project directory. This will install the necessary roles and collections.

You will need to create vaults in the host_vars subfolder with the necessary variables, as specified in the existing `vars.yml` folder.

Finally, ensure you have an ssh-agent running. The first thing ansible will do is attempt to unlock the provided ssh key and add it to the agent.

## mailcow configuration

It is necessary to login and and change the admin password manually.
The default username is `admin` and the password is `moohoo`.
After doing so, follow the below instructions to get keycloak configured
as an identity provider for mailcow. Note that keycloak will already be
configured in this way, you just need to do the mailcow part.

https://mailcow.email/posts/2023/mailcow-idp/

## orangehrm configuration

You will unfortunately need to login and complete the guided web setup as per [here](https://starterhelp.orangehrm.com/hc/en-us/articles/5295915003666-OrangeHRM-Starter-Installation-Guide). You will want to specify the db to be the companion docker mysql container. Once that process is complete and you can login as the administrator.

From there, you can create a "social media login" which is actually just an OIDC client. Directions [here](https://starterhelp.orangehrm.com/hc/en-us/articles/12392313182236--Set-up-Social-Media-Authentication). The values should already be configured in keycloak at this point, so you should fill them in as such:

Name: keycloak
Client ID: orangehrm
Provider URL: https://<your-kc-domain>/realms/<your-realm>
Client Secret: As defined in the ansible vault or in keycloak admin console.

OrangeHRM is currently the only service provided by hierarch that will not provision an account on first login. In order to create an employee record, please refer to their documentation, and then specify the email as the same one that is in the user's keycloak account. They will then be able to login via keycloak.

## forgejo configuration



## backup configuration

While the backup is configured and set to run automatically with borgmatic, you must first manually login and initialize the repos. This is intentional, as it gives you the chance to backup the very important repokeys. These should be stored in a separate location / password store from the repo passphrase.

The repos can be initiated with the command `sudo borgmatic init --encryption repokey` on each host. To backup the repokey, see the [borg documentation](https://borgbackup.readthedocs.io/en/stable/index.html).

## Credits

Thanks to all contributers who of the roles/collections in the `requirements.yml`.

Special thanks to [enough](https://lab.enough.community/main/infrastructure) and [ansible-middleware](https://github.com/ansible-middleware/keycloak), as some of the roles here are based on their work.

## License

AGPLv3.0 or later