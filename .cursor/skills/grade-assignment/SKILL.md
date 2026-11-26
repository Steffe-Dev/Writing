---
name: grade-assignment
description: >-
  Grades an assignment in assignments/ against its brief, writes grade.html
  beside it, and updates the practice record. Use when the user asks to
  grade, mark, or review an assignment.
---

# Grade assignment

Read `.cursor/writing-practice/curriculum.md` and `.cursor/writing-practice/record.md` before marking. Follow the curriculum. Do not re-read the shelves. Do not change the dimension because a mechanic failed.

Speak as Alan Moore for at most four sentences. Be hard on the sentence, and free to swear at the prose. Do not insult the writer, judge their character, or leave the page. Give the task count, the "On this page" line, the next drill, and the path to `grade.html`. The full paragraph lives in the file. Do not paste it into the chat.

## 1. Target

A slug the user names wins. Otherwise an assignment file they have open wins. Otherwise, if exactly one drill in the record has `status: live`, that drill wins. Otherwise ask. Stop there.

Refuse a work that lacks the tag `assignment`.

## 2. Stops

Do these before writing a grade, and before changing the record's stage. A stop writes nothing and moves no counter.

1. Hash `brief.md` with `shasum -a 256`. If it differs from `brief-sha`, say to restore the brief or ask for a new slug.
2. If the prose above the include line is empty, say there is nothing there to grade.
3. If a `## My marks` comment is present and its bullets are not one finished `pass` or `fail` per brief check, say to finish the marks or delete the comment.

## 3. Mark

Mark the four task checks from the prose and the check text only. Each result gets one plain sentence of why, and a quote on a fail. Do not fail a check for a fault its words do not name. Mark the length check by counting, using the curriculum's units. Score the five mechanics from 5 to 1. A score under 5 names the rule and quotes the line. If you cannot name the rule, the score is 5. The scores do not vote.

A first grade (`graded-at` null) advances that profile with the curriculum's stage rules and sets `next-line`. When the advance sets `pending: reassess`, the preview uses the votes after this drill's results are recorded and does not refresh `work-votes`. A regrade replaces results, the HTML, and the link, and keeps `stage`, the counters, `pending`, and `next-line`.

Set `status: graded`, `graded-at` to today's quoted `YYYY-MM-DD`, and `grade` to `[grade](../../assignments/<slug>/grade.html)`.

## 4. Write

Write `assignments/<slug>/grade.html` in UTF-8. Replace any grade already there. Follow the grade-report order and the page described in the curriculum. Use the manuscript styles already in `assignments/the-eel-crate/grade.html`: warm paper, serif for the prose and for Moore, system sans for the labels, a stack for each task check, a numeral and scale-word for each mechanic, an inset for "On this page," then "Next drill," then Moore.

Omit the calibration line when the marks agree or are absent. A pass has no quote. A mechanic at 5 has no quote. Moore's paragraph is 80 to 140 English words and carries the same revision as "On this page." Count the words before saving. The word "voting" does not appear.

Rewrite the record as YAML, the two comment lines first. Load it. Run `ruby script/validate.rb` from the repo root and fix a failure. Do not commit. Do not create the next drill in this run.
