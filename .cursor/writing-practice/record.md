# Practice record. Dates are quoted strings. The whole file is YAML.
# The skills read and write this file. Drill prose is not stored here.

selection: fixed
default: en
profiles:
  en:
    enabled: true
    stage: opening-probes
    opening-index: 2
    follow-index: 0
    hold-dimension: null
    hold-rep: 0
    hold-streak: 0
    gap-dimension: null
    pending: none
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
            result: fail
          - text: The prose above the include line is between 150 and 400 words.
            kind: length
            result: pass
        mechanics:
          viewpoint: fail
          tense: fail
          plan-residue: pass
          stock-phrasing: fail
          surface: fail
