---
sidebar_position: 4
---

# Documentation

Effective documentation plays a pivotal role in the success of software products. huronOS, designed for configuration by contest managers and utilization by contestants, places a strong emphasis on comprehensive documentation. Our website primarily serves as a repository for this essential information.
Here is some best practices for writing huronOS docs.

## Language Standardization

*English* serves as the default language for both coding and documentation. This choice is grounded in the widespread usage of English among developers, ensuring broad accessibility to our documentation. While other languages are not prioritized, we welcome contributions from translators.

## Documentation Repository

Our documentation resides in the [huronOS-build-tools/docs](https://github.com/equetzal/huronOS-build-tools/docs) directory. This repository maintains the association between huronOS version tags and corresponding documentation. Commits made to the `huronOS-build-tools -> development` branch trigger a GitHub action to update the [website](https://github.com/huronOS/website) repository, adhering to the rule:
- Commits on branch `huronOS-build-tools -> development` are mirrored to the `website -> development` branch.

## Technology Stack

For documentation and website development, we rely on [Docusaurus](https://docusaurus.io), an optimized static site generator in React. This tool seamlessly integrates JavaScript, React, and Markdown, allowing us to create a dynamic website. While utilizing React components when necessary, we prioritize the simplicity of our website codebase.

Docusaurus also facilitates Google indexing, ensuring quick access to the desired content and emphasizing content over UI.

## Markdown Usage

All documentation is composed in the `.md` extension. We avoid the use of `.mdx` (Docusaurus markdown equivalent to `.jsx` files) to maintain compatibility with various markdown rendering tools and prevent limiting our documentation to a select few. Although there are no text editor extensions/plugins for rendering Docusaurus markdown style, we recommend leveraging the *Hot Reload* feature.

## Writing with Docusaurus Hot-Reload

As documentation is authored in the *huronOS-build-tools* repository but rendered by Docusaurus in the *website* repository, enabling hot reload requires symlinking the `website/docs` directory to `huronOS-build-tools/docs`. This can be done manually or by using our `website/dev-start.sh` script, especially if both repositories are located at the same directory level. It's advisable to have both repositories checked out at the @development branch (or your branch based on development).

## Submitting Documentation PR

To streamline the process of submitting documentation, follow these steps:
1. Create a skeleton file outlining the structure and topics to be covered.
2. Capture ideas without being overly concerned with spelling, grammar, or structure.
3. Refine content to align with the skeleton file and improve overall structure.
4. Address major spelling and grammar issues to ensure clarity.
5. Create a draft PR to preserve the original text.
6. Utilize chatGPT to rewrite your markdown file with the provided prompt:
```txt
Please rewrite the following markdown text to look professional, with software terminology, good grammar and oriented to technically skilled people. Make sure to do not delete the links, images, nor changing the titles and keep the tables format. Properly escape triple backtick codeblocks with 4 backticks. Please, output the rewrite in markdown format in a codeblock so that I can just copy it. 

# Here paste your markdown content
```
7. Copy and paste the chatGPT version, review, and commit the changes to your PR.
8. Thoroughly review the chatGPT version, correcting any mistakes, ensuring accurate wording, and confirming that no points are lost. Repeat as needed until satisfied.
9. Amend/commit corrections and submit them to your PR.
10. Request technical review from a developer to validate accuracy.
11. Seek review from an English professional to ensure clarity and suitability for public use.
12. Merge your documentation. Thank you for your valuable contribution! 😊
