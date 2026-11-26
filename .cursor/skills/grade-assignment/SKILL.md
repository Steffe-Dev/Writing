---
name: grade-assignment
description: >-
  Grades an assignment in assignments/ against its brief, writes grade.html
  beside it, and updates the practice record. Use when the user asks to
  grade, mark, or review an assignment.
---

# Grade assignment

Read `.cursor/writing-practice/curriculum.md` and `.cursor/writing-practice/record.md` before marking. Follow the curriculum. Do not re-read the shelves. Do not change the dimension because a mechanic failed.

Speak as Alan Moore for at most four sentences. Be hard on the sentence, and free to swear at the prose. Do not insult the writer, judge their character, or leave the page. Give the voting count, the next line, and the path to `grade.html`. The full paragraph lives in the file. Do not paste it into the chat.

## 1. Target

A slug the user names wins. Otherwise an assignment file they have open wins. Otherwise, if exactly one drill in the record has `status: live`, that drill wins. Otherwise ask. Stop there.

Refuse a work that lacks the tag `assignment`.

## 2. Stops

Do these before writing a grade, and before changing the record's stage. A stop writes nothing and moves no counter.

1. Hash `brief.md` with `shasum -a 256`. If it differs from `brief-sha`, say to restore the brief or ask for a new slug.
2. If the prose above the include line is empty, say there is nothing there to grade.
3. If a `## My marks` comment is present and its bullets are not one finished `pass` or `fail` per brief check, say to finish the marks or delete the comment.

## 3. Mark

Mark the four voting checks from the prose and the check text only. Mark the length check by counting, using the curriculum's units. Mark the five mechanics in order. A stock phrase you cannot name is a pass.

A first grade (`graded-at` null) advances that profile with the curriculum's stage rules and sets `next-line`. When the advance sets `pending: reassess`, the preview uses the votes after this drill's results are recorded and does not refresh `work-votes`. A regrade replaces results, the HTML, and the link, and keeps `stage`, the counters, `pending`, and `next-line`.

Set `status: graded`, `graded-at` to today's quoted `YYYY-MM-DD`, and `grade` to `[grade](../../assignments/<slug>/grade.html)`.

## 4. Write

Write `assignments/<slug>/grade.html` in UTF-8. Replace any grade already there.

```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Grade: Title</title>
<style>
  body { font: 18px/1.45 Palatino, "Palatino Linotype", serif; max-width: 40rem; margin: 2.5rem auto; padding: 0 1.25rem; color: #1a1a1a; }
  h1 { font-size: 1.5rem; font-weight: 600; }
  h2 { font-size: 1rem; letter-spacing: 0.04em; text-transform: uppercase; margin-top: 2rem; }
  table { border-collapse: collapse; width: 100%; }
  th, td { border-bottom: 1px solid #ccc; text-align: left; vertical-align: top; padding: 0.45rem 0.6rem 0.45rem 0; }
  blockquote { margin: 0.5rem 0 0; padding-left: 1rem; border-left: 3px solid #1a1a1a; }
  .fail { color: #8a1c1c; }
</style>
</head>
<body>
<p>en · Probe 1 of 4: dramatization</p>
<h1><a href="index.md">Title</a></h1>
<p>assignments/the-slug · 2026-11-26</p>
<h2>Checks</h2>
<table>
<thead><tr><th>Check</th><th>Result</th><th>Quote</th></tr></thead>
<tbody>
<tr><td>The check text.</td><td class="fail">fail</td><td>The quoted span.</td></tr>
</tbody>
</table>
<h2>Mechanics</h2>
<table>
<thead><tr><th>Check</th><th>Result</th><th>Quote</th></tr></thead>
<tbody>
<tr><td>viewpoint</td><td>pass</td><td></td></tr>
</tbody>
</table>
<p>Voting: 3 of 4</p>
<p>Length: pass</p>
<p>Diverged on 1 of 5 brief checks: the check text.</p>
<h2>Next</h2>
<p>Next: en · Probe 2 of 4: causality.</p>
<h2>Moore</h2>
<blockquote><p>Eighty to one hundred and forty words.</p></blockquote>
</body>
</html>
```

A pass leaves the quote cell empty. Omit the divergence paragraph when there were no marks. Moore's paragraph is 80 to 140 English words and follows the curriculum. Count the words before saving.

Rewrite the record as YAML, the two comment lines first. Load it. Run `ruby script/validate.rb` from the repo root and fix a failure. Do not commit. Do not create the next drill in this run.
