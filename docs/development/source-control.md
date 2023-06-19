---
sidebar_position: 2
---

# Source Control

We are **pioneers** in the use of [Sapling-SCM](https://sapling-scm.com), which is a Git-SCM compatible client developed by Meta. Sapling-SCM aims to bring the experience of their internal tool called **SmartLog**. This client is an *old fork* of Mercurial-SCM and has implemented/changed several features that make this tool **truly unique**. We recommend reading the [launch notes](https://engineering.fb.com/2022/11/15/open-source/sapling-source-control-scalable/) about the system. 

Using Sapling-SCM allows us to continue development even while waiting for code reviews, providing an **unblocked workflow**. It is especially beneficial for operations such as `amend` and `rebase`.

On the server side, we store all of our code in **Github** using Git-SCM. We have set up Github actions to automate various aspects of our infrastructure. Both Git-SCM and Sapling-SCM can be used with our repositories, but we **recommend Sapling** for developers and Git for those exploring the source code.

In all of our repositories, we follow a **trunk-based** development model but use the ***rebase-and-merge*** merging strategy instead of the regular *3-way-merge* used in Github. As a result, our branching strategy is as follows:

- **`development`**, the default branch  
    This is the **most updated branch** and contains all the merged pull requests. Please note that code in this branch has not been tested in contests.

- **`main`**, versioning cut branch  
    This branch **follows the development branch**. Periodically, after the development branch has accumulated enough commits or features, we perform a **version cut** to generate a new system build. This branch will always be at the latest build tag that has been **successfully built** and tested for the current code. You can securely checkout this branch to create your own build.

- **`stable`**, contest-tested branch  
    This branch **follows the main branch**, but it only moves forward to a version that has been **rock-tested** to work. While this does not provide a warranty (as our GPL license states), you can expect a build version on this branch to be more **reliable** than other build tags.

Since Sapling-SCM enforces the **stacked commits** paradigm, we recommend using [reviewstack.dev](https://reviewstack.dev) as the main review tool for all the source code. This tool enhances the experience of reviewing stacked commits, something that Github is not particularly good at.

> **Notes:**
> - If you are new to Stacked Commits, we encourage you to read [this article](https://jg.gg/2018/09/29/stacked-diffs-versus-pull-requests/), which provides a comprehensive introduction by comparing regular pull requests with stacked diffs (stacked commits, stacked PRs, etc.). This development paradigm can save you a lot of time.
> - Sapling is still an early client for the public, even though it has been rock-tested internally at Meta. Therefore, you can expect some missing features and potential issues when working with Github. If you encounter any problems, please report them to the [Sapling public repo](https://github.com/facebook/sapling/issues).
