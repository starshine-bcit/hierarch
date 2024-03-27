# hierarch

Proof of concept open-source enterprise tech stack, implemented with ansible.

## Overview

Do we really need Google, Microsoft, etc., for a small tech-oriented business? Hierarch was imagined as a replacement for a proprietary technology stack that many organizations run. A small IT team could manage Hierarch for a small organization and maintain a reasonable level of compliance & security.

This repository, and associated submodule, are not production ready. It is designed as a POC that could be customized to meet the needs of a given organization. The system, as a whole, is designed to be compatible with both cloud and on-prem deployments.

The POC is composed of three servers. Debian 12 (bookworm) is the only supported distribution at time of writing.

### Common Components

With the exception of the mail server, each one has nginx, certbot, ufw, and postgres configured.

### Admin

The so-called admin server is an identity provider, hosting Keycloak.

This server, in it's current configuration, is also responsible for hosting and mirroring the automated backups from the other servers. The backups are designed in this fashion:

1. Each server has it's own Borg archive on the backup (admin) server, which it write to daily. An arbitrary number of daily, weekly, and monthly backups are retained.
2. Daily, the backup server mirrors an encrypted tgz of each archive to some cloud provider (not implemented in POC). Alternately, a provider with borg support could be used, then a separate backup location specified in the borgmatic config.
3. Weekly, it is intended that someone rsyncs each borg archive to a rotating external drive, which should be stored in a secure location.

The admin server hosts a dashboard which is meant to act as a homepage for users, making it easier to access the various services.

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
- coturn
- Element Web
- Cryptpad
- Wiki.js
- OrangeHRM

It is worth noting that OrangeHRM only supports specific versions of MySQL or MariaDB, so it has a companion database container.

Spec for POC:

- 8 Epyc Milan vcore
- 16 GB RAM
- 160 GB SSD

## How to do?

First clone the repository, including the `--recurse-submodule` flag. This tells git to checkout the submodule, which is an ansible collection that contains a number of roles required for Hierarch.

In order to run the configuration, you will need to have a modern Linux system with a full Ansible installation. The [documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#pipx-install) has a guide on how to install it with pipx (recommended).

After installing Ansible, then run `ansible-galaxy install -r requirements.yml` in the project directory. This will install the necessary roles and collections.

You will need to create vaults in the host_vars subfolder with the necessary variables, as specified in the existing `vars.yml` folder.

Next, create a `borg_ssh` and `borg_ssh.pub` key files using `ssh-keygen`. These files should exist in the `./resource` directory so ansible can access them during the backup configuration.

Finally, ensure you have an ssh-agent running. The first thing ansible will do is attempt to unlock the provided ssh key and add it to the agent.

### mailcow configuration

It is necessary to login and and change the admin password manually.
The default username is `admin` and the password is `moohoo`.
After doing so, follow the below instructions to get keycloak configured
as an identity provider for mailcow. Note that keycloak will already be
configured in this way, you just need to do the mailcow part.

https://mailcow.email/posts/2023/mailcow-idp/

Once the identity provider is configured, you will need to setup the domain in the e-mail -> configuration -> domains section of the webui. From there, regular users part of the correct keycloak group should be able to access and send email.

### orangehrm configuration

You will unfortunately need to login and complete the guided web setup as per [here](https://starterhelp.orangehrm.com/hc/en-us/articles/5295915003666-OrangeHRM-Starter-Installation-Guide). You will want to specify the db to be the companion docker mysql container. Once that process is complete and you can login as the administrator.

From there, you can create a "social media login" which is actually just an OIDC client. Directions [here](https://starterhelp.orangehrm.com/hc/en-us/articles/12392313182236--Set-up-Social-Media-Authentication). The values should already be configured in keycloak at this point, so you should fill them in as such:

Name: keycloak
Client ID: orangehrm
Provider URL: https://<your-kc-domain>/realms/<your-realm>
Client Secret: As defined in the ansible vault or in keycloak admin console.

OrangeHRM is currently the only service provided by hierarch that will not provision an account on first login. In order to create an employee record, please refer to their documentation, and then specify the email as the same one that is in the user's keycloak account. They will then be able to login via keycloak.

### forgejo configuration

The forgejo instance should just work out of the box, however an Admin may want to create some organizations or do further configuration of the runners, as they are currently setup to only run Debian 12 Docker images.

### cryptpad configuration

Any user configured in Keycloak should be able to login to cryptpad. In order to create an admin user, please follow [these directions](https://docs.cryptpad.org/en/admin_guide/installation.html#configure-administrators). Alternately, you can modify the appropriate variable in ansible and rerun the playbook to insert the adminKey.

### wikijs configuration

An admin user will be provisioned by ansible. The admin should login and disable registration. They can also turn on Bypass Login Screen and Hide Local Authentication Provider in order to streamline the user login procedure. Should you need to access the local login as an admin, add `?all=1` to the login url.

Once that is done, you can setup some groups, permissions, as well as define a default group for new users.

### matrix configuration

An admin user is created by ansible. It is recommended the adminstrator login via a desktop matrix client to perform further configuration. If needed, extra administrator accounts can be setup using the [User Admin API](https://matrix-org.github.io/synapse/latest/admin_api/user_admin_api.html#change-whether-a-user-is-a-server-administrator-or-not).

The synapse server is configured with two channels which new users are auto-joined to, and are not encrypted. Users should be invited to the correct spaces/channels when they first login by a mod/admin.

### backup configuration

While the backup is configured and set to run automatically with borgmatic, you must first manually login and initialize the repos. This is intentional, as it gives you the chance to backup the very important repokeys. These should be stored in a separate location / password store from the repo passphrase.

The repos can be initiated with the command `sudo borgmatic init --encryption repokey` on each host. To backup the repokey, see the [borg documentation](https://borgbackup.readthedocs.io/en/stable/index.html).

## User Groups

For demonstration purposes, there are several predefined groups in Keycloak. A newly provisioned user should be added to at least the user group.

- admin: These users have full administrative control over the realm
- developer: Grants access to forgejo
- forgejo_admin: Grants administrative access to forgejo
- user: Grants access to Synapse and Mailcow

There are a couple other roles present, but unfortunately the OIDC support is relatively limited in some of the services. This means that by virtue of existing, a user is granted access to anything not mentioned in this section.

## Cloud deployment

Include the `./terraform` folder is a terraform config to deploy 3 three servers on AWS with roughly the same capabilities as the VPSs described above, and includes IPv6 configuration. This is provided purely for demontration purposes, and would not be a recommended way to deploy hierarch. This is due to two reasons: AWS is very expensive, and it also does not allow outgoing mail traffic.

However, if you were to go this route, you would want to apply some basic hardening prior to pointing the main ansible playbook at it, such as setting up another user with a password-protected ssh private key and a password-protected sudo access.

## Further Reading

For more detailed information on each of the roles used, please refer to the [hierarch-collection](https://github.com/starshine-bcit/hierarch-collection) repository and readme.

## Credits

Thanks to all contributers who of the roles/collections in the `requirements.yml`.

Special thanks to [enough](https://lab.enough.community/main/infrastructure) and [ansible-middleware](https://github.com/ansible-middleware/keycloak), as some of the roles here are based on their work.

## License

AGPLv3.0 or later