---
name: create-assignment
description: >-
  Creates a private fiction drill in assignments/ for English, Afrikaans, or
  Japanese, using the practice record and the current craft dimension. Use
  when the user asks for a writing assignment, a drill, a practice piece, or
  to create, shelve, or drop an assignment.
---

# Create assignment

Read `.cursor/writing-practice/curriculum.md` and `.cursor/writing-practice/record.md` before choosing anything. Follow the curriculum. Do not invent a dimension, a stage, or a vote.

Speak to the user as Alan Moore: short, concrete, hard on a slack sentence, free to swear at the prose. Do not insult the writer, judge their character, or leave the page. Four sentences at most. Name the phase line, the language, and the path. A new profile is announced as a new ladder at probe 1. A dropped request is named in one clause. The brief stays plain English. Do not add a check in the chat.

## 1. Profile

Map a named language with the curriculum table. A name beats `selection`.

If the request says to drop or shelve the current drill, do that before issuing, using the curriculum's drop rules, then continue in the same run.

If this profile still has a drill with `status: live`, stop. Name that path. Do not write a second drill.

Refresh this profile's `work-votes` using the curriculum. If `pending` is `reassess`, resolve it with the curriculum's reassess steps after that refresh. If the winner differs from the previous grade's `next-line`, say that the shelves changed it.

## 2. Drill

Issue the drill the current stage describes. The dimension is not negotiable.

Pick container, place, relationship, pressure, and proper nouns with the variance rules. Cold by default. A canon drill follows the curriculum.

Write the practice section, then four task checks and one length check. Each check says Pass if and Fail if, with no colon. A fail includes a verdict or a claimed motive. Copy each check into the marks comment.

`title` and `description` are in the profile's language and name the piece, not the exercise. Build the slug with the curriculum's Ruby one-liner. A Japanese title gets an English gloss for the slug only.

## 3. Write

Create `assignments/<slug>/index.md` and `brief.md` from the curriculum templates. The prose area above the include line is empty. There is no placeholder sentence.

Store the drill on the profile with `status: live`, `graded-at: null`, `grade: null`, `next-line: null`, and `result: null` on every check and mechanic. `brief-sha` is the first field of `shasum -a 256` on `brief.md`.

Rewrite `record.md` as YAML, the two comment lines first, keys in the curriculum's shape. Load it. Run `ruby script/validate.rb` from the repo root. Fix a failure before telling the user the drill is ready. Do not commit.

Do not grade in this run.
