# Requirement Defect Taxonomy
## Secure Voting System

This file documents defects found during requirement analysis.
The same table appears in the SRS (Section 7) — this is the standalone version for the `/requirements` folder.

---

| ID | Requirement | Defect Type | Description | Resolution |
|----|------------|-------------|-------------|-----------|
| D-01 | FR-04 (Cast Vote) | **Ambiguity** | "Anonymity is preserved" was not precisely defined. It could mean: (a) ballot has no voter ID attached, or (b) the link is encrypted and only unlockable later | Resolved: ballot stores only candidate choice; voter ID is architecturally excluded from the ballot type |
| D-02 | NFR-01 (Integrity) | **Non-verifiability** | "Votes cannot be altered after submission" is an implementation goal — not formally verifiable without a mathematical definition | Resolved: expressed as Z invariant `ballots' ⊇ ballots` — the ballot set only grows, never shrinks |
| D-03 | FR-07 (View Results) | **Incompleteness** | No requirement specified who can view results and under what conditions — could a voter see results before election closes? | Added: results viewable only by Auditor role; only in TALLIED state |
| D-04 | NFR-04 (Completeness) | **Inconsistency** | NFR-04 ("every ballot counted") and FR-06 ("votes per candidate") conflicted when considering spoiled ballots | Resolved: scope restricted to valid ballots only; spoiled ballots explicitly out of scope for this model |
| D-05 | FR-03 (Open Election) | **Ambiguity** | "At least 1 voter registered" — ambiguous whether registered means only recorded, or also verified/approved by admin | Clarified: registration = eligibility; no separate approval step in this model |

---

## Defect Type Definitions

| Type | Meaning |
|------|---------|
| **Ambiguity** | Requirement can be interpreted in more than one way |
| **Inconsistency** | Two requirements contradict each other |
| **Non-verifiability** | Requirement cannot be tested or formally verified as stated |
| **Incompleteness** | A scenario or condition is not addressed by any requirement |
