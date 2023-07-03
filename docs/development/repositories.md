---
sidebar_position: 3
---

# Repositories

Our code repositories are hosted on Github. Initially, we created our first repository under the Github user profile [equetzal](https://github.com/equetzal) to take advantage of the Github Student Pack and Github Pro features during her university studies. Subsequently, we established the [huronOS Github Organization](https://github.com/orgs/huronOS/repositories) to house all our new repositories. Eventually, we plan to migrate the first repository, huronOS-build-tools, to the organization. However, being a free organization, we do not have access to certain advanced features on Github. If we receive enough donations in the future, we may consider purchasing Github Enterprise or a similar solution. Alternatively, if we have our own infrastructure, we might explore the option of self-hosting with GitLab.

## Current Repositories

Below is the current structure of our code repositories:

### [huronOS-build-tools](https://github.com/equetzal/huronOS-build-tools)

This is the primary repository containing a collection of scripts that facilitate the construction of huronOS using a Debian installation as the base. It also serves as a quasi-monorepo, encompassing numerous scripts, features, configurations, and software that are utilized by the system but not distributed across multiple repositories. Additionally, this repository includes documentation, ensuring that the documentation stays synchronized with the evolving codebase.
> **Note:**
> We may consider transitioning to the Debian packaging system in the future, which could impact this repository's structure.

### [website](https://github.com/huronOS/website)

This repository houses the source code for our website, [huronos.org](https://huronos.org). We have developed the website using [Docusaurus](https://docusaurus.io), an MIT-licensed tool created by Meta. Docusaurus enables us to write documentation using Markdown, create components using React, and deploy the entire website as a static, indexable page that is searchable by search engines such as Google. We have automated the deployment process using Github Actions. The `development` branch is automatically deployed to [staging.huronos.org](https://staging.huronos.org), while the `main` branch is deployed to [huronos.org](https://huronos.org), with any pending TODO files being excluded.

### [syslinux](https://github.com/huronOS/syslinux)

We maintain our own fork of Syslinux, which allows us to parallelize the huronOS installer when installing the system on multiple USB drives connected to the same computer, such as through a USB hub.

### [bookmark-bridge](https://github.com/huronOS/bookmark-bridge)

To ensure synchronization between the bookmark settings and the [directives file](../usage/directives/creating-a-directives-file.md), we utilize this extension. It enables the bookmarks to be updated even after the user has opened the browser for the first time. Our goal is to replace the current `initial_bookmarks` approach, which does not allow for bookmark updates once the browser has been launched.

## Planned Repositories

We have several new repositories planned to accommodate different components of huronOS.

### debian-packages

This repository will house the code for our tools, which will be packaged for the Debian packaging system. These packages will be deployed to our own *apt* repository located at *deb.huronos.org*.

### installer

In the future, we intend to separate the installer from the huronOS-build-tools repository. This separation will allow us to enhance the installer by incorporating a user interface, ensuring compatibility with various operating systems, and introducing a guided step-by-step installation process.

### contest-arranger

This repository is part of our plan to enable the usage of huronOS without relying on a synchronization file. To achieve this, we require a dedicated local software that allows users to configure the system for a contest directly. The repository will contain the code for this graphical user interface (GUI) software, facilitating the configuration of huronOS for contests held locally.
With this software, users will have greater flexibility in customizing the system to meet their specific contest requirements, and test the system without needing to sync to a server.

### sync-manager

We intend to separate the sync manager functionality from the huronOS-build-tools repository. The sync manager plays a crucial role in tracking synchronization with the directives server and managing the versioning of the directives file.

### package-manager

The hpm (huronOS-package-manager) project will enable huronOS to remotely add or remove available (downloaded) software, allowing users to activate or deactivate software through the directives file. This feature will significantly reduce the size of the ISO files and enable a broader range of use cases for the operating system.

### directives-api

Currently, huronOS utilizes a plain text directive file. However, we are working on implementing an API that will enable the creation of "code rooms" for the system, facilitate the redirection of directives to "super rooms," and integrate with an easy-to-use manager dashboard.

### manager-dashboard

The manager dashboard will work in conjunction with the directives API, providing users with a comprehensive interface to configure huronOS and monitor the status of all connected systems. Users will be able to view system statuses, receive alerts, announcements, and perform other administrative tasks.
