# Practice record. Dates are quoted strings. The whole file is YAML.
# The skills read and write this file. Drill prose is not stored here.

selection: fixed
default: en
profiles:
  en:
    enabled: true
    stage: opening-probes
    opening-index: 3
    follow-index: 0
    hold-dimension: null
    hold-rep: 0
    hold-streak: 0
    gap-dimension: null
    pending: none
    carry:
      text: "Pass if a feeling on the page is carried by an object or a physical action already there. Fail if a comparison or a ready-made gesture does that feeling's work."
      source: the-empty-tin
      fails: 0
    work-votes:
      - work: short-stories/i-ended-the-world-on-my-way-to-work
        dimension: dramatization
        quote: "Chichi (part of a discriminated-against race of humanoid rodents), walks to work. He is an intuitive master of LOTU, but the reader does not know that, and nor does he."
    drills:
      - slug: the-eel-crate
        path: assignments/the-eel-crate
        title: The Eel Crate
        language: en
        container: opener
        situation: Ivo lifts a stranger's eel crate under the canvas at Brine while hail falls.
        place: stall
        relationship: stranger
        pressure: weather
        proper-nouns:
          - Ivo
          - Brine
        canon-work: null
        dimension: dramatization
        phase-line: "en · Probe 1 of 4: dramatization"
        next-line: "en · Probe 2 of 4: causality"
        advanced: true
        form: fragment
        band: "150-400"
        band-unit: words
        brief-sha: "def941e423226471224f28674c08c8cf910e3beb6462c7e2aa2203f5973e9d08"
        status: graded
        graded-at: "2026-11-26"
        grade: "[grade](../../assignments/the-eel-crate/grade.html)"
        checks:
          - text: The first sentence contains a physical action.
            kind: voting
            result: pass
          - text: By the end, the crate's place or the person's grip on it has changed.
            kind: voting
            result: pass
          - text: The change follows from an earlier action in the scene, not from a new wish announced at the end.
            kind: voting
            result: pass
          - text: No sentence tells the reader what the person feels without a visible action or object attached.
            kind: voting
            result: pass
          - text: The prose above the include line is between 150 and 400 words.
            kind: length
            result: pass
        mechanics:
          viewpoint: 3
          tense: 4
          plan-residue: 5
          stock-phrasing: 4
          surface: 4
      - slug: the-empty-tin
        path: assignments/the-empty-tin
        title: The Empty Tin
        language: en
        container: dialogue
        situation: Hester tells Piet the rent tin is empty, and his answer moves the ticket or the tin.
        place: kitchen
        relationship: kin
        pressure: money
        proper-nouns:
          - Hester
          - Piet
        canon-work: null
        dimension: causality
        phase-line: "en · Probe 2 of 4: causality"
        next-line: "en · Probe 3 of 4: viewpoint"
        advanced: true
        form: fragment
        band: "150-400"
        band-unit: words
        brief-sha: "1e9a082f26377950c097d610623ca52d593366c93e140b4337288795ab95eeef"
        status: graded
        graded-at: "2026-11-27"
        grade: "[grade](../../assignments/the-empty-tin/grade.html)"
        checks:
          - text: Pass if the first sentence gives a fact that a later action uses. Fail if it only thinks, feels, or announces a motive.
            kind: voting
            result: pass
          - text: Pass if one spoken sentence causes the next physical move. Fail if the narrator explains that move with a feeling or a verdict.
            kind: voting
            result: pass
          - text: Pass if that move uses a fact already on the page. Fail if a new wish arrives and does the work.
            kind: voting
            result: pass
          - text: Pass if the last change in who holds an object, or who is in the room, follows from the speech just before it. Fail if the last sentence judges the relationship or names a motive.
            kind: voting
            result: pass
          - text: Pass if the prose above the include line is between 150 and 400 words. Fail if it falls outside that band.
            kind: length
            result: pass
        mechanics:
          viewpoint: 5
          tense: 5
          plan-residue: 5
          stock-phrasing: 2
          surface: 5
