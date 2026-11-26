# Practice curriculum

`create-assignment` and `grade-assignment` follow this file. The memory is `.cursor/writing-practice/record.md`. The whole record is YAML. After every edit, load it. If it does not load, fix it before finishing.

```shell
ruby -ryaml -rdate -e 'src = File.read(ARGV[0]); m = YAML.method(:safe_load); if m.parameters.any? { |k, n| k == :key && n == :permitted_classes }; YAML.safe_load(src, permitted_classes: [Date], aliases: false); else YAML.safe_load(src, [Date], [], false); end' .cursor/writing-practice/record.md
```

Drill prose is never copied into the record. A quote stored here is one or two sentences.

## Languages

Profiles are `en`, `af`, and `ja`. Anything else is refused, and the refusal names these three.

| Request | Profile |
| --- | --- |
| en, English | en |
| af, Afrikaans | af |
| ja, Japanese | ja |

A named language selects that profile, ahead of `selection`. Asking for a language that has no profile creates it and sets `enabled: true`. Creating one starts it at probe 1. Say so. Asking again for a disabled profile sets `enabled: true`.

`selection` is `fixed`, `random`, or `least-used`. Any other value is refused, and the refusal names these three.

With no language named:

- `fixed` uses `default`. If that profile is missing or disabled, refuse and name the enabled profiles.
- `random` picks uniformly among enabled profiles with no live drill. Use `ruby -e 'puts ARGV.shuffle.first'`. If none qualify, refuse and name the live drills.
- `least-used` uses the same pool. Pick the fewest drills with `graded-at` set. A regrade does not add a drill. A shelved drill with no `graded-at` does not count. Ties go to the oldest `graded-at`. A profile with none is older than any date. Dates are `YYYY-MM-DD` and sort as strings. A remaining tie goes `en`, then `af`, then `ja`. The reply names the profile and each compared count.

With only `en` enabled, all three settings pick `en`.

`enabled: false` keeps the tally and drops the profile from `random` and `least-used`.

One live drill per profile. A drill is live when `status` is `live`.

## Dimensions

Keys, in tie-break order, and the words used in a phase line:

| Key | Phase-line name |
| --- | --- |
| dramatization | dramatization |
| causality | causality |
| viewpoint | viewpoint |
| dialogue | dialogue |
| concrete-particulars | concrete particulars |
| sentence-shape | sentence shape |
| diction | diction |
| promise | promise |

`promise` means the promise of the opening or the turn, at the scale of the drill.

Votes are failures. Length and mechanics never vote. Surface errors never become the dimension.

`votes(profile, dimension)` is the number of `kind: voting` checks with `result: fail` on drills in that profile whose `dimension` is that key and whose `graded-at` is set, plus one for each `work-votes` entry with that dimension.

`rank(pool)` is the dimension in `pool` with the most votes. A tie takes the earlier row in the table.

A dimension has been probed when some graded drill in the profile has that `dimension`.

## What a vote from the shelves is

On every create, before choosing, replace that profile's `work-votes`. Grade does not read the shelves.

Scan every shelf except `assignments`. Skip dot directories, `script`, and `.github`. A work is `shelf/slug.md` or `shelf/slug/index.md`. Skip a work tagged `assignment`. The primary language is the first `languages` entry. Keep works whose primary language is this profile.

Count the prose with the metadata removed. A multi-file work counts `index.md` and its parts. Under 150 words, or under 400 non-whitespace characters when the primary language is `ja`, the work adds no vote. It may still be quoted in a probe brief.

If a passage clearly fails one dimension, store one entry: `work` (the work id, no suffix), `dimension`, and `quote`. Several failures still produce one entry, for the clearest failure. A work that does not show a clear failure adds nothing. Do not force a vote.

A work under the threshold cannot be the only reason for a hold. The short published piece on the `en` shelf is under the threshold.

## Stages

`stage` is `opening-probes`, `follow-probes`, `hold`, `gap-probe`, or `maintenance`.

`pending` is `none` or `reassess`. Create issues the drill. The first grade of that drill advances the counters below. A regrade replaces results and does not advance counters, `pending`, or `stage`.

Opening probes, in order, while `opening-index` is 1 through 4. The phase line is `{lang} · Probe {opening-index} of 4: {name}`. Work votes do not change this order. After the first grade of probe 4, set `pending: reassess` and leave `opening-index` at 4. After probes 1–3, add 1 to `opening-index`.

Follow-up probes use the last four dimensions. `follow-index` is how many of them are already graded. The next key is row `4 + follow-index` of the table, and the phase line is `{lang} · Probe {5 + follow-index} of 8: {name}`. After each first grade, add 1 to `follow-index`. When that addition reaches 4, set `pending: reassess`.

A hold's phase line is `{lang} · Hold {hold-rep + 1} of 3: {name}` for `hold-dimension`. On each first grade, add 1 to `hold-rep` and to `hold-streak`. When `hold-rep` reaches 3, set `pending: reassess`.

A gap probe's phase line is `{lang} · Probe: {name}` for `gap-dimension`. On its first grade, set `pending: reassess`.

Maintenance's phase line is `{lang} · Maintenance: {name}`. Choose the dimension with the fewest graded drills. A tie takes the earlier row. On a first grade, if any voting check failed, set `stage: hold`, `hold-dimension` to that dimension, `hold-rep: 0`, `hold-streak: 0`, and `pending: none`. If none failed, stay in maintenance.

## Reassess

When create finds `pending: reassess`, refresh `work-votes` first, then do this. The grade that set `pending` may have named a preview. If the refresh changes the winner, say so in the chat and follow the refresh.

Opening probes: pool is the first four dimensions. If every one has 0 votes, set `stage: follow-probes`, `follow-index: 0`, `pending: none`. Otherwise start a hold on `rank(pool)` and reset the streak.

Follow-up probes or a gap probe: pool is every probed dimension. If all eight have been probed and every dimension has 0 votes, enter maintenance. Otherwise start a hold on `rank(pool)` and reset the streak.

A finished hold: take the three newest graded drills whose `dimension` is `hold-dimension` and whose `phase-line` contains `Hold`. The cycle is clean when none of their voting checks failed. Pool is every probed dimension. If all eight have been probed and the cycle is clean, enter maintenance. Otherwise let the winner be `rank(pool)`. If the winner is `hold-dimension` and `hold-streak` is at least 6, the winner is blocked. Prefer the earliest never-probed dimension and start a gap probe: `stage: gap-probe`, `gap-dimension` set, `pending: none`, and the streak left as it is. If every dimension has been probed, the winner is `rank` of the pool without `hold-dimension`, and that starts a hold with the streak reset. The reassess after the gap probe starts a hold and resets the streak, so the run of six is over. If the winner is `hold-dimension` and the streak is under 6, keep the dimension, set `hold-rep: 0`, set `pending: none`, and leave the streak.

Starting a hold sets `stage: hold`, `hold-dimension`, `hold-rep: 0`, `pending: none`. Resetting the streak sets `hold-streak: 0`. A new dimension always resets it.

Entering maintenance sets `stage: maintenance`, `pending: none`, `hold-dimension: null`, `hold-rep: 0`, `hold-streak: 0`, `gap-dimension: null`.

A new profile:

```yaml
enabled: true
stage: opening-probes
opening-index: 1
follow-index: 0
hold-dimension: null
hold-rep: 0
hold-streak: 0
gap-dimension: null
pending: none
work-votes: []
drills: []
```

## Variance

Containers, in rotation order: `opener`, `dialogue`, `ending`, `letter`, `action`, `description`.

| Container | What the prose is |
| --- | --- |
| opener | The first movement. The story does not finish. |
| dialogue | A spoken exchange that changes the relationship. |
| ending | The last movement, after a choice. |
| letter | A written message from one person to another. |
| action | A physical task that starts and then changes. |
| description | A place or an object, and the change happens in the looking. |

The relationship is one of: `none`, `stranger`, `kin`, `friend`, `lover`, `child`, `employer`, `enemy`, `crowd`, `animal`, `institution`.

The pressure is one of: `deadline`, `money`, `grief`, `pursuit`, `bargain`, `shame`, `weather`, `work`, `illness`, `hunger`, `danger`.

Compare with the last drill in that profile, shelved ones included. The first drill in a profile has nothing to differ from. Otherwise the new drill differs in container, place, relationship, pressure, and proper nouns. Place is the kind of location. A synonym of the previous kind is the same place. A proper noun used in the previous drill stays unused, unless this drill is a canon drill and the name is already in the cited work.

A requested container or situation is used only when the dimension stays the one selected and the variance rules hold. Otherwise issue the drill the sequence requires and say which request you dropped.

Default the form to `fragment`. Use `flash` when the brief asks for a piece that starts and finishes inside the band. Use `short-story` only when the dimension cannot be tested smaller, say why in the brief, and set the band you actually need.

Default band: `150-400` `words` for `en` and `af`, `400-1000` `characters` for `ja`. Characters are non-whitespace. A wider or narrower band is allowed and the brief says why.

## Canon

The shelves of non-assignment works, in every language, are the canon. Votes still stay inside the profile's language.

Most drills are cold: new people, no names from the canon. A dramatization drill may be a canon drill when a work shows summary or plan-notes where a scene should be. Any other canon drill has to be asked for, and the facts asked for have to be on the page already.

A canon drill's situation starts with `This drill uses only what {title} ({work id}) already states.` The prose adds no fact that work does not state. Container and pressure still change.

## Brief

`brief.md` is English. It does not open with `---`. The first line is `# The assignment`.

A probe does not call the dimension a weakness. A hold shows the votes that put the dimension in the lead.

Checks are one line each, with no colon, no `--`, and no `<!--`. A stranger can mark each one pass or fail from the prose. `Make it haunting` is not a check. Write four voting checks about the current dimension, then the length check:

- Words: `The prose above the include line is between 150 and 400 words`
- Characters: `The prose above the include line is between 400 and 1000 characters, not counting whitespace`

Use the drill's real band in that sentence.

```markdown
# The assignment

en · Probe 1 of 4: dramatization

## Situation

A person in a borrowed coat has to cross one room and get a key off a table without the owner turning around.

## Length and form

150–400 words. Fragment.

## Constraints

Write above the include line in index.md. One scene. No notes to yourself.

## Checks

1. The first sentence contains a physical action.
2. By the end, the person's location or their grip on an object has changed.
3. The change follows from an earlier action in the scene, not from a new wish announced at the end.
4. No sentence tells the reader what the person feels without a visible action or object attached.
5. The prose above the include line is between 150 and 400 words.

## Evidence

None of the shelves bears on this dimension.
```

When a passage bears on a probe, quote it under Evidence with the work id, and do not call it a weakness. When nothing bears, use that exact sentence: `None of the shelves bears on this dimension.`

A hold's Evidence names each failed voting check that gave the dimension its votes: the drill slug, the check text, and the failing span from that grade. A work quote may follow. A work under the threshold cannot be the only item in that section.

## Mechanics

Marked on every grade, in this order. They do not vote.

| Key | Fail |
| --- | --- |
| viewpoint | A second mind is entered, or a mind is read with no visible cue. |
| tense | The narration leaves its primary tense. A quoted speaker may use another. |
| plan-residue | Brackets, a heading that is an outline, `TODO`, or a note to the writer. Summary inside the fiction is a dramatization failure, not this one. |
| stock-phrasing | A phrase you can name as stock, and can quote. If you cannot name the pattern, this check passes. |
| surface | Spelling, agreement, a homophone, a particle, or an idiom. One result. Quote one example. |

## Files of a drill

```text
assignments/<slug>/index.md
assignments/<slug>/brief.md
assignments/<slug>/grade.html
```

`index.md` keys, in this order: `title`, `description`, `form`, `status`, `languages`, `tags`, `published`. `status` is `draft` until a drop sets `shelved`. `languages` is the one profile tag. `tags` is a list of the single string `assignment`. `published` is the unquoted boolean `false`. No `completed` key.

`title` and `description` name the piece in the profile's language. `description` is one line, 1–200 characters, and it is filled in. `title` is one line, 1–120 characters.

The slug is ASCII kebab-case and is never renamed. Fold a Latin title with marks stripped, lowercase, anything else becoming hyphens, trimmed to 60 characters on a hyphen. If that fold is empty, fold a 2–6 word English gloss instead. The gloss is not the title. `index` and `readme` are reserved. A collision with a file or directory takes `-2`, then `-3`.

```shell
ruby -e 's = ARGV[0].unicode_normalize(:nfd).gsub(/\p{Mn}/, "").downcase.gsub(/[^a-z0-9]+/, "-").gsub(/\A-|-\z/, ""); puts s' "The Title"
```

`index.md` prose area is empty. The writer fills it above the include.

```markdown
---
title: The Borrowed Coat
description: Someone crosses a room for a key that is not theirs.
form: fragment
status: draft
languages:
  - en
tags:
  - assignment
published: false
---

{% include_relative brief.md %}

<!--
## My marks

Leave one word on each line, pass or fail. Delete this whole comment to skip.

- The first sentence contains a physical action: pass / fail
-->
```

One marks bullet per check, in order, the check text copied exactly, then `: pass / fail`.

`brief-sha` is the first field of `shasum -a 256` on `brief.md`, taken at create. Grade stops if the file no longer matches. Say to restore `brief.md` or ask for a new slug. Do not grade.

## Record fields of a drill

```yaml
- slug: the-borrowed-coat
  path: assignments/the-borrowed-coat
  title: The Borrowed Coat
  language: en
  container: action
  situation: A person crosses one room for a key.
  place: room
  relationship: stranger
  pressure: danger
  proper-nouns: []
  canon-work: null
  dimension: dramatization
  phase-line: "en · Probe 1 of 4: dramatization"
  next-line: null
  form: fragment
  band: "150-400"
  band-unit: words
  brief-sha: "0123456789abcdef"
  status: live
  graded-at: null
  grade: null
  checks:
    - text: The first sentence contains a physical action.
      kind: voting
      result: null
    - text: The prose above the include line is between 150 and 400 words.
      kind: length
      result: null
  mechanics:
    viewpoint: null
    tense: null
    plan-residue: null
    stock-phrasing: null
    surface: null
```

`status` is `live`, `graded`, or `shelved`. `graded-at` is a quoted `YYYY-MM-DD` or null. `grade`, once set, is the markdown link `[grade](../../assignments/<slug>/grade.html)`. `next-line` is set on the first grade and kept on a regrade. `canon-work` is a work id or null.

Rewrite `record.md` with the two comment lines on top and keys in this shape. Then load it.

## Dropping a drill

A drop is explicit. If more than one drill is live and the request names no slug and no language, ask, and shelve nothing. If only one is live, that one is the target.

Set that work's `status` to `shelved`. Set the drill's `status` to `shelved`. Do not change `stage`, the indexes, the streak, or `pending`. Counters move only on a first grade, so the same phase is issued again under a new slug. Then create that drill in the same run.

## Length of the prose

The prose is the text after the front matter and before the line `{% include_relative brief.md %}`, trimmed. Empty prose is not graded. The phase does not move.

Words are whitespace-separated. Japanese characters are every character that is not whitespace. The length check passes when the count sits inside the band, inclusive.

## Marks

If no comment contains `## My marks`, skip calibration. If it does, there is one bullet per brief check, in order. The text after the last colon, trimmed, is `pass` or `fail`. Anything else, or the wrong number of bullets, stops the grade. No grade file. The phase does not move. Say to finish the marks or delete the comment.

Calibration counts brief checks, the four voting checks and the length check. A divergence is a mark that differs from the rubric. The line is plain: `Diverged on 2 of 5 brief checks:` and the check texts. Moore does not write it. A later grade after the comment is gone omits the line.

## Grade report

`grade.html` is UTF-8, English, and links to `index.md`. It is excluded from the site. Replacing it is the whole history. Do not keep the old file.

The page has:

1. The phase line, the date, the work id, and a link to `index.md`.
2. Every brief check, pass or fail, and a quote from the prose on each fail.
3. The five mechanics, in the table order, the same way.
4. The lines `Voting: 3 of 4` and `Length: pass` or `Length: fail`. No letter and no score out of 100.
5. The calibration line, when the marks were complete.
6. One plain sentence: `Next: {next-line}.` On a first grade, `next-line` is the phase line of the drill create will issue next. When this grade sets `pending: reassess`, compute that preview from the record after this drill's results are written, and before any shelf is reread. A regrade keeps the stored `next-line`.
7. Moore, 80 to 140 English words. He quotes two substrings of the prose, one that earns its place and one that does not. If the prose has only one sentence, he says so and both quotes are taken from it. If nothing earns its place, he says so and the first quote is the least slack span. He judges the fictional move. He does not add a check, change a result, or name a different next drill. Notes on spelling, particles, agreement, and idiom stay on the surface row.

Then run `ruby script/validate.rb` from the repo root. Fix a failure before treating the run as done. Do not commit.
