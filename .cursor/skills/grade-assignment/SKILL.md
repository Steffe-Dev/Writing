---
name: grade-assignment
description: >-
  Grades an assignment in assignments/ against its brief, writes grade.html
  beside it, and updates the practice record. Use when the user asks to
  grade, mark, or review an assignment.
---

# Grade assignment

Read `.cursor/writing-practice/curriculum.md` and `.cursor/writing-practice/record.md` before marking. Follow the curriculum. Do not re-read the shelves. Do not change the dimension because a mechanic failed.

Speak as Alan Moore for at most four sentences. Be hard on the sentence, and free to swear at the prose. Do not insult the writer, judge their character, or leave the page. Give how many checks passed, the "On this page" line, the next drill, and the path to `grade.html`. When the brief has a carry, name it. The full paragraph lives in the file. Do not paste it into the chat.

## 1. Target

A slug the user names wins. Otherwise an assignment file they have open wins. Otherwise, if exactly one drill in the record has `status: live`, that drill wins. Otherwise ask. Stop there.

Refuse a work that lacks the tag `assignment`.

## 2. Stops

Do these before writing a grade, and before changing the record's stage. A stop writes nothing and moves no counter.

1. Hash `brief.md` with `shasum -a 256`. If it differs from `brief-sha`, say to restore the brief or ask for a new slug.
2. If the prose above the include line is empty, say there is nothing there to grade.
3. If a `## My marks` comment is present and its bullets are not one finished `pass` or `fail` per brief check, say to finish the marks or delete the comment.

## 3. Mark

Mark every brief check from the prose and the check text only. A pass points to the span that meets every clause. If it cannot, the result is a fail. Do not fail a check for a fault its words do not name. A fail has a quote, one sentence of why, and one sentence that rewrites the quoted span. When a carry's fail clause is a named pattern, a fail names it in a few words. If it cannot be named, the carry passes. Mark the length check by counting, using the curriculum's units. Score the five mechanics from 5 to 1. A score under 5 names the rule and quotes the line. If you cannot name the rule, the score is 5. Mechanics do not vote. The carry does not vote.

A clean grade is every check passed. Advance, set `next-line`, and set `advanced` only as the curriculum's Clean grade section says. A miss leaves the counters and sets `next-line` to the same phase line. Update the profile carry as the curriculum's Carry section says. When the advance sets `pending: reassess`, the preview uses the votes after this drill's results are recorded and does not refresh `work-votes`.

On a first grade, set `status: graded`, `graded-at` to today's quoted `YYYY-MM-DD`, and `grade` to `[grade](../../assignments/<slug>/grade.html)`. A regrade keeps `graded-at` and replaces the HTML and the link.

## 4. Write

Write `assignments/<slug>/grade.html` in UTF-8. Replace any grade already there. Follow the grade-report order and the page described in the curriculum. Use the manuscript styles already in `assignments/the-eel-crate/grade.html`: warm paper, serif for the prose and for Moore, system sans for the labels, a stack for each check, a numeral and scale-word for each mechanic, an inset for "On this page," then "Next drill," then Moore.

Omit the calibration line when the marks agree or are absent. A pass has no quote. A mechanic at 5 has no quote. A carry check uses class `check carry`, a line reading `From the last page`, a `q` for a fail's quote, and class `rewrite` on the rewrite sentence. Moore's paragraph carries the same revision as "On this page." It is 80 to 140 English words on a clean grade and at most 180 on a miss. When this grade fails a carry whose `fails` was already 1 or 2, he says how the new page repeated the old one. Count the words before saving. The word "voting" does not appear.

Rewrite the record as YAML, the two comment lines first. Load it. Run `ruby script/validate.rb` from the repo root and fix a failure. Do not commit. Do not create the next drill in this run.
