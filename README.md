# Writing

This repo is the source for my writing works. Each work carries a YAML metadata block. GitHub Pages builds a public index from those blocks. This file is the grammar.

`published: false` keeps a work off the site. The file is still in the repo. A draft that should stay private stays uncommitted.

Word count, reading time, and the public URL are computed when the site is built. They are not fields in the block.

## Works

A shelf is a top-level directory. `script`, `.cursor`, and `.github` are reserved and are not shelves. `short-stories` is a shelf.

A work id is the repo-relative path with the file suffix removed.

- `short-stories/the-glass-harbor.md` is the work `short-stories/the-glass-harbor`.
- `short-stories/the-glass-harbor/index.md` is the same work.
- Those two paths must never both exist.

A one-file work is `shelf/slug.md`. That file holds the metadata.

A multi-file work is a directory, `shelf/slug/`. `index.md` holds the same metadata. Every other `.md` file beside it is a part. The directory is flat. Slugs and part filenames are kebab-case. A work slug is never `index` or `readme`.

To turn a one-file work into a multi-file work, move the file to `index.md` inside a new directory of the same name, then add part files beside it. The metadata moves with the file. The id stays the same.

```text
short-stories/the-glass-harbor.md
```

becomes

```text
short-stories/the-glass-harbor/index.md
short-stories/the-glass-harbor/01-the-hull.md
short-stories/the-glass-harbor/02-the-town.md
```

Parts are read in filename order. Use zero-padded prefixes (`01-`, `02-`) so that order matches the reading order. A part's label is its first heading. The body of a work, and a part, may be empty.

A shelf may also contain a `README.md` that does not open with a metadata block. Anything else in a shelf is invalid. Notes live outside the work, because every markdown sibling of `index.md` is a part.

## Metadata

The metadata is a YAML block at the start of the work file, between lines that are exactly `---`. The index reads this block and nothing else in the file.

The allowed keys are the ones below. Any other key is invalid. Adding a key means updating this README and `script/validate.rb` in the same change. Series, content warnings, and prior publication are future keys. They are invalid until this grammar adds them.

Write the keys in this order. The validator accepts any order.

| Key | Required | Value |
| --- | --- | --- |
| `title` | always | One line, 1–120 characters, no surrounding whitespace |
| `description` | when `published` is true | One line of plain text, 1–200 characters, no surrounding whitespace |
| `form` | always | One of the forms below |
| `status` | always | `draft`, `revising`, `done`, or `shelved` |
| `completed` | when `status` is `done` | A `YYYY-MM-DD` date. Omit it for every other status |
| `languages` | always | A non-empty list of locale tags. The first tag is the primary language |
| `tags` | no | Unique kebab-case strings. Omit the key, or use `[]`, when there are none |
| `published` | always | The boolean `true` or `false`, written unquoted |

`published` is written on every work. A missing value would be treated as true by Jekyll. Write `true` or `false` only. `yes`, `no`, and quoted `"false"` are invalid.

A work may be `published: true` while `status` is `draft` or `revising`, as long as `description` is present.

A locale tag is a lowercase language of two or three letters (`en`, `af`), optionally followed by a script (`zh-Hans`) and then a region (`en-ZA`, `zh-Hans-CN`). The catalog groups works by form. A work appears once, and the card shows every language.

`completed` may be quoted or unquoted. It has to be a real calendar date.

```markdown
---
title: The Glass Harbor
description: A diver finds the town's name written on the hull.
form: short-story
status: draft
languages:
  - en
  - af
tags:
  - sea
published: false
---

The first paragraph of the story.
```

When the work is finished, set `status: done` and add `completed: 2026-11-01` on the line after `status`.

## Forms

Every form uses the same fields. The values are `short-story`, `flash`, `poem`, `essay`, `novel`, `fragment`, and `song`.

A draft novel is `form: novel` and `status: draft`. `fragment` is a piece that is deliberately a fragment.

## Parts, scene breaks, and assets

A part has no metadata block. It must not open with a `---` line. A `---` line later in a body is a scene break, in a part or in the work file.

Images and other non-markdown files in the work directory are assets. The validator ignores them. They sit next to `index.md`, because the directory cannot contain subdirectories.

## Site

GitHub Pages builds the `main` branch with Jekyll, from the repository root. The site is `https://steffe-dev.github.io/Writing/`. A push of `published: true` publishes that work. The page shows the title and the body. The public URL is the work id with a trailing slash.

The homepage groups published works by form, in the order listed under Forms. A card shows the description, every language, the word count, and a reading time of 200 words a minute, rounded up. The title links to the work. With nothing published, the page says "Nothing published yet."

This build does less than the grammar describes:

- A multi-file work's page is `index.md` only. Parts stay in the repo. Word count and reading time count that file only.
- The catalog does not show a last edit.
- Asset files in a work directory are copied to the site when the work is unpublished.
- A workflow runs `script/validate.rb` on every push and every pull request. The Pages build does not wait for it, so a work that fails the validator is still published.

## Validator

The validator is `script/validate.rb`. It uses the Ruby standard library and needs nothing installed. It checks the repository that contains it.

From the repo root:

```shell
ruby script/validate.rb
```

A clean repo prints nothing and exits 0. When something is wrong, every problem is printed to stderr as `path: message`, and the command exits 1.

Work files, parts, and shelf READMEs are UTF-8 without a byte order mark.

GitHub runs this command on every push and every pull request.
