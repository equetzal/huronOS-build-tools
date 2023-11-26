---
sidebar_position: 6
---

# Development Standards

huronOS development requires writing code in different environments which can lead to the use of different editors like *nano*, *vi*, or GUI powered editors like *vscode*. In any case, we are still inclined to maintain certain quality standards in our codebase to keep collaboration simpler.

## Editing Code
We recommend you use vscode as the main editor as it provides you with several extensions that can help maintain the quality of code we're looking for at the codebase. Either way, there'll be a time when you'll have to use a terminal based editor, so we encourage you to polish your code as much as possible but don't forget to lint, format and check your code before committing it.

## Spelling
English is the main language for all the code and documentation in huronOS, this is intentional mainly due to globalization, this way most of the people involved is able to familiarize themselves with the codebase; that's why it is important to keep our code with the best spelling and grammar possible, from the variable naming, to the code comments, documentation and overall resources. We recommend using VScode's [Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker) extension, to catch all the spelling issues as you write. You can also use your own tooling but please keep this request in mind when doing so.

## Shell Scripting

### Formating
All of the shell scripting styling follows the default configuration of [shfmt](https://github.com/mvdan/sh) which can be integrated with several code editors or executed from the terminal.
We recommend the [VScode extension](https://marketplace.visualstudio.com/items?itemName=foxundermoon.shell-format) for *shfmt* which can be activated on save, making it easier to follow the standard.

### Linting
For shell scripting linting, we recommend using [Shellcheck](https://github.com/koalaman/shellcheck) which provides static code analysis to catch important bugs when writing shell scripts, which can be actually challenging to debug, track and find. If you're using VScode, there's a [ShellCheck extension](https://github.com/vscode-shellcheck/vscode-shellcheck) you can use.
