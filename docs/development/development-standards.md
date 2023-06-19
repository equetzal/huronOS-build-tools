---
sidebar_position: 6
---
# Development Standards

huronOS development requires writing code in different environments which can lead to the use of different editors like *nano*, *vi*, or GUI powered editors like *vscode*. In any case, we are still inclined to maintain certain quality standards in our codebase to keep collaboration simpler.

## Editing Code
We recommend you use vscode as the main editor as it provides you with several extensions that can help maintain the quality of code we're looking for at the codebase. Either way, there'll be a time when you'll have to use a terminal based editor, so we encourage you to polish your code as much as possible but don't forget to lint, format and check your code before committing it.

## General Recommendations
We have several general recommendations for developing huronOS. 

### Spelling
English is the main language for all the code and documentation in huronOS, this is intentional mainly due to globalization, this way most of the people involved is able to familiarize themselvers with the codebase; that's why it is important to keep our code with the best spelling and grammar possible, from the variable naming, to the code comments, documentation and overall resources. We recommend using VScode's [Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker) extension, to catch all the spelling issues as you write. You can also use your own tooling but please keep this request in mind when doing so.

## Shell Scripting

### Formating
All of the shell scripting styling follows the default configuration of [shfmt](https://github.com/mvdan/sh) which can be integrated with several code editors or executed from the terminal.
We recommend the [VScode extension](https://marketplace.visualstudio.com/items?itemName=foxundermoon.shell-format) for *shfmt* which can be activated on save, making it easier to follow the standard.

### Linting
For shell scripting linting, we recommend using [Shellcheck](https://github.com/koalaman/shellcheck) which provides static code analysis to catch important bugs when writing shell scripts, which can be actually challenging to debug, track and find. If you're using VScode, there's a [ShellCheck extension](https://github.com/vscode-shellcheck/vscode-shellcheck) you can use.

## Documentation
Documentation is written on the [huronOS-build-tools](https://github.com/equetzal/huronOS-build-tools) repository, this keeps a relation between huronOS' versioning and its documentation. Documentation is built by using [Docusaurus](https://docusaurus.io), but the project is also the implementation of the [huronos.org](https://huronos.org) website, which its code is on the [huronOS-website](https://github.com/huronOS/huronOS-website) repository. The code submitted under the `huronOS-build-tools/docs` directory triggers a Github action to commit those changes to the website repo, and automatically deploy those changes using the following rules:
- Pulls/Merges on the *unstable* branch, will commit on the website's *staging* branch and deploy to Github Pages a.k.a. [Staging](https://huronos.github.io/huronOS-website/).
- Pulls/Merges on the *main* branch, will commit on the website's *main* branch but will not be deployed.
- When releasing on Github, the action will checkout the release tag and commit those changes to the website's *stable* branch. This will create a new docusaurus documentation version and then will trigger a deploy on the [huronos.org](https://huronos.org) (production) website, which contains the documentation of all the official releases on huronOS-build-tools.

### Markdown
All the documentation is written in the markdown `.md` extension. We don't use `.mdx` (docusaurus markdown equivalent to `.jsx` files) as it minimizes compatibility with several markdown render tools and limit our documentation to few tools. There's no VScode extension for rendering the Docusaurus markdown style, but we'd advise using the *Hot Reload* feature.
As an alternative to hot reload, you can use the [Github Markdown Renderer](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-preview-github-styles) VScode extension, but it will also render Docusaurus' specific metadata which might not be the ideal.

### Docusaurus Hot Reload
Please, clone the huronOS-website@staging and huronOS-build-tools@unstable repos at the same directory level, then run:
```bash
cd huronOS-website
./dev-start.sh
```
