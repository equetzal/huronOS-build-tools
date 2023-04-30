---
sidebar_position: 4
---
# Development Standards
> WIP: This file stills work in progress

huronOS development requires to write code in different environments which can lead to use different editors like *nano*, *vi*, or GUI powered editors like *vscode*. In any case, we still preferring to maintain certain quality and standards in our codebase to keep collaboration simpler.

## Editing Code
We recommend you to use vscode as the main editor as it provides with several extensions that can help you to maintain the quality of code we're looking for the codebase. Anyway, in some cases you'll be needing to use a terminal based editor, and we recommend to polish your code as mush as possible but lint, format and check your code as soon as possible.  

## General Recommendations
We do have several general recommendations for developing huronOS. 

### Spelling
English is the main language for all the code and documentation in huronOS, this is on purpose for internationalization so that most of people is able to familiarize with the codebase; because of this, it is important to keep our code with the best spelling as possible, in the variable naming, code comments, documentation and overall resources. We do recommend using the VScode [Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker) extension to catch all the spelling issues as you write. You can also use your own tooling but please keep this present.

## Bash Scripting

### Formating
All the styling for bash follows the default configuration of [shfmt](https://github.com/mvdan/sh) which can be integrated with several code editors or be run from the terminal. 
We do recommend the [VScode extension](https://marketplace.visualstudio.com/items?itemName=foxundermoon.shell-format) for shfmt which can be activated on save, making easier to follow the standard.

### Linting
For bash scripting linting, we do recommend using [Shellcheck](https://github.com/koalaman/shellcheck) to provide static code analysis to catch important bugs when writing bash scripts, which can be actually very hard to debug, track and find. If using VScode, there's a [ShellCheck extension](https://github.com/vscode-shellcheck/vscode-shellcheck).

### IntelliSense
TODO

## Documentation
Documentation is written on the [huronOS-build-tools](https://github.com/equetzal/huronOS-build-tools) repository, this is to keep a relation between the huronOS version and the documentation according to that version. Documentation is built by using [Docusaurus](https://docusaurus.io), but the project is also the implementation of the [huronos.org](https://huronos.org) website which code is on the [huronOS-website](https://github.com/huronOS/huronOS-website) repository. The code submitted under the `huronOS-build-tools/docs` directory triggers a Github action to commit those changes to the website repo and deploy those changes with the following rules:
- Pulls/Merges on the *unstable* branch, will commit on the website *staging* branch and deploy to Github Pages a.k.a. [Staging](https://huronos.github.io/huronOS-website/).
- Pulls/Merges on the *main* branch, will commit on the website *main* branch but will not be deployed.
- Releases on the *stable* branch will commit the changes of the release tag on the website *stable* branch, will create a new docusaurus documentation version and then will trigger a deploy on the [huronos.org](https://huronos.org) (production) website, which contains the documentation of all the official releases on huronOS-build-tools.

### Markdown
All the documentation is written in markdown `.md` extension. We don't use `.mdx` (docusaurus markdown equivalent to `.jsx` files) as it minimize compatibility with several markdown render tools and limit our documentation to few tools. There's no VScode extension for rendering the Docusaurus markdown style, but we do recommend going to the [huronOS-website](https://github.com/huronOS/huronOS-website) repository, clone it and use the [hot reload](https://github.com/facebook/docusaurus/pull/663) feature and symlink your `docs/` directories to use hot reload while editing on the *huronOS-build-tools* repo.
As an alternative, you can use the [Github Markdown Renderer](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-preview-github-styles) VScode extension, but it will also render Docusaurus specific metadata which might not be the ideal.

### Docusaurus Hot Reload
Please, clone the huronOS-Website and huronOS-build-tools repos and checkout staging and your desired version respectively. Then run:
```bash
rm -rf ./docs
ln -sf ../huronOS-build-tools/docs ./docs
yarn install
yarn start
```

## Version Control
TODO

### Commits Quality
TODO

### Stacked PRs
TODO: Goal

### Git
TODO: Current state
Git Tree extension

### Sapling SCM
TODO: Goal
Migration goal
SmartLog extension
Blockers: Multi-root workspaces