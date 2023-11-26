---
sidebar_position: 4
---

# Documentation
Documentation is a vital part of software products, and huronOS as a system oriented to be setup by contest managers and used by contestants, it's vital to document as much as possible the system, how to use it,  how it is configured and how it works; this is why our website is mostly, documentation. 

## Language
We use *English* as the default language for both coding and documenting; this is because this language is the most widely used by developers and this provides access to most people around the globe to our docs. Other languages are not a priority, but if you want to become a translator we'll be happy to receive your contributions.

## Where is documentation stored?
Our documentation is written on the [huronOS-build-tools/docs](https://github.com/equetzal/huronOS-build-tools/docs) directory; we use this repository to keep a relation between huronOS' version tags and its documentation. The code submitted under this directory triggers a Github action to commit those changes to the [website](https://github.com/huronOS/website) repository using the following rule:
- Commits on branch `huronOS-build-tools -> development` goes to `website -> development` branch.

## Tech Stack
To build our documentation and website we use [Docusaurus](https://docusaurus.io), which is an optimized static site generator in React that allow us mix Javascript, React and Markdown to build the website. Using React components when needed, but allowing us to write simple markdown files which are amazingly rendered while keeping our website codebase simple.

Docusaurus also allow us to be Google-indexed for you to quickly find the content you're looking for and to focus on just the content and not the UI.

## Markdown
All the documentation is written in the markdown `.md` extension. We try not to use `.mdx` (docusaurus markdown equivalent to `.jsx` files) as it minimizes compatibility with several markdown render tools and limit our documentation to few tools. There's no text editors extensions/plugins for rendering the Docusaurus markdown style, but we'd advise using the *Hot Reload* feature.

## Writing with Docusaurus' hot-reload
As we write docs on *huronOS-build-tools* repo but they're actually rendered by Docusaurus on the *website* repos; to use hot reload you need to symlink the `website/docs` directory to the `huronOS-build-tools/docs` one. 
You can do this manually, or by using our `website/dev-start.sh` script in case you have both repos on the same directory level. It's recommended to have checked out both repos at @development branch (or with your branch base on development). 

## Sending documentation PR
When writing a doc we suggest you the following path:
1. Create an skeleton file of the structure and topics you want to cover in your doc.
2. Write your ideas as they come, without caring much about spelling, grammar or structure.
3. Re-write your content to fit your skeleton file and try to structure it better.
4. Fix any major spelling and grammar mistakes to make sure that the point is clear and not confused by anything else.
5. Make a draft PR to keep track of your original text.
6. Ask chatGPT to re-write your markdown file with the following prompt:
```txt
Please rewrite the following markdown text to look professional, with software terminology, good grammar and oriented to technically skilled people. Make sure to do not delete the links, images, nor changing the titles and keep the tables format. Properly escape triple backtick codeblocks with 4 backticks. Please, output the rewrite in markdown format in a codeblock so that I can just copy it. 

# Here paste your markdown content
```
7. Copy and paste the chatGPT re-wrote and amend or commit, then push your changes to your PR. 
8. Read the chatGPT version and correct any mistake, make sure that the wording is accurate and the point is not lost. Check for missing sections and recover them if needed. Repeat this if you feel that it's needed util you feel comfortable with your result.
9. Amend / Commit your corrections and send them to your PR. 
10. Ask for a developer to review your PR. This is highly important as we need all the technical parts to be accurate.
11. Ask for an english professional to review your PR. This is the last filter to ensure that the point is clear and the text is apt for public use.
12. Merge your doc! Thank you for contributing! :D

