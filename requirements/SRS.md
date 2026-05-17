# Software Requirements Specification (SRS)
## Secure Voting System
**Version:** 1.0  
**Course:** Software Verification & Validation (SVV) Lab  
**Date:** May 2026

---

## Table of Contents
1. Introduction
2. Overall Description
3. System States
4. Functional Requirements
5. Non-Functional Requirements
6. System Invariants
7. Requirement Defect Taxonomy
8. Glossary

---

## 1. Introduction

### 1.1 Purpose
This document specifies the functional and non-functional requirements of a **Secure Voting System** designed for use in an organizational or institutional election. It serves as the foundation for formal modeling using Z Notation, VDM, and Alloy.

### 1.2 Scope
The system allows eligible voters to register, authenticate, and cast exactly one anonymous ballot. It enforces integrity (no tampering), anonymity (vote unlinkability), and single-vote constraints.

### 1.3 Definitions

| Term | Definition |
|------|-----------|
| **Voter** | A person who is registered and eligible to participate in the election |
| **Ballot** | The formal record of a voter's choice |
| **Candidate** | A person standing for election |
| **Election** | A bounded event with a defined start and end time |
| **Tally** | The aggregated count of votes per candidate |
| **Anonymity** | The property that a ballot cannot be linked back to the voter who cast it |
| **Integrity** | The property that votes cannot be altered, deleted, or fabricated after submission |

---

## 2. Overall Description

### 2.1 System Context
The Secure Voting System operates within a controlled institutional environment. It has three categories of users: **Admin**, **Voter**, and **Auditor**.

### 2.2 User Classes

| Role | Responsibilities |
|------|----------------|
| Admin | Registers voters, registers candidates, opens/closes election |
| Voter | Authenticates, casts one ballot |
| Auditor | Views tally, verifies election integrity |

### 2.3 Assumptions and Dependencies
- Each voter has a unique, pre-assigned Voter ID
- The system is single-election (one active election at a time)
- Network-level security (TLS) is assumed to be handled externally

---

## 3. System States

The system passes through exactly **four states**:

```
SETUP → OPEN → CLOSED → TALLIED
```

| State | Description |
|-------|------------|
| **SETUP** | Admin registers voters and candidates; no voting allowed |
| **OPEN** | Election is live; voters may cast ballots |
| **CLOSED** | Voting period ended; no new ballots accepted |
| **TALLIED** | Results computed and published |

**State transition rules:**
- SETUP → OPEN: Admin opens the election (at least 1 voter and 1 candidate registered)
- OPEN → CLOSED: Admin closes the election
- CLOSED → TALLIED: System computes tally
- No reverse transitions are allowed

---

## 4. Functional Requirements

### FR-01: Voter Registration
- **Description:** Admin can register a voter by providing a unique Voter ID and name
- **Pre-condition:** System is in SETUP state; Voter ID does not already exist
- **Post-condition:** Voter is added to the registered voters set; voter's voted status = false

### FR-02: Candidate Registration
- **Description:** Admin registers a candidate with a unique Candidate ID
- **Pre-condition:** System is in SETUP state; Candidate ID does not already exist
- **Post-condition:** Candidate is added to the candidates set

### FR-03: Open Election
- **Description:** Admin opens the election to begin the voting period
- **Pre-condition:** System is in SETUP state; at least 1 voter and 1 candidate exist
- **Post-condition:** System state transitions to OPEN

### FR-04: Cast Vote
- **Description:** A registered voter casts a vote for a candidate
- **Pre-condition:** System is in OPEN state; voter is registered; voter has NOT voted; candidate is valid
- **Post-condition:** Ballot is recorded; voter's voted status = true; anonymity is preserved (ballot not linked to voter identity)

### FR-05: Close Election
- **Description:** Admin closes the voting period
- **Pre-condition:** System is in OPEN state
- **Post-condition:** System state transitions to CLOSED

### FR-06: Compute Tally
- **Description:** System computes vote counts per candidate
- **Pre-condition:** System is in CLOSED state
- **Post-condition:** Tally is computed; system state transitions to TALLIED

### FR-07: View Results
- **Description:** Auditor views the tally
- **Pre-condition:** System is in TALLIED state
- **Post-condition:** Vote counts per candidate are displayed

---

## 5. Non-Functional Requirements

### NFR-01: Integrity
No vote may be modified or deleted once cast. The ballot set is append-only during OPEN state.

### NFR-02: Anonymity
The system shall not store any direct mapping from a voter to their specific ballot choice. The only association recorded is that the voter has voted (boolean flag).

### NFR-03: Single Vote Enforcement
Each voter may cast a ballot at most once. This is enforced by checking the voter's `hasVoted` flag before accepting any ballot.

### NFR-04: Completeness of Tally
Every ballot cast must be counted. The total vote count must equal the number of voters whose `hasVoted` flag is true.

### NFR-05: Availability
The system must be accessible throughout the OPEN state without interruption.

---

## 6. System Invariants

The following invariants **must hold at all times**:

### INV-1: Single Vote Invariant
> Every voter who has voted appears in the voter's record exactly once, and no voter may vote more than once.

Formal: `∀ v ∈ Voters · v.hasVoted = true ⟹ v occurs in ballots exactly once`

### INV-2: Candidate Validity Invariant
> Every ballot must reference a valid registered candidate.

Formal: `∀ b ∈ Ballots · b.candidateId ∈ dom Candidates`

### INV-3: Ballot Anonymity Invariant
> No ballot is linked to a specific voter's identity.

Formal: `dom Ballots ∩ dom Voters = ∅` (ballot IDs and voter IDs are disjoint)

### INV-4: Tally Consistency Invariant (post-tallied)
> The total number of ballots equals the number of voters who have voted.

Formal: `# Ballots = # { v ∈ Voters | v.hasVoted = true }`

---

## 7. Requirement Defect Taxonomy

| ID | Requirement | Defect Type | Description | Resolution |
|----|------------|-------------|-------------|-----------|
| D-01 | FR-04 (Cast Vote) | **Ambiguity** | "Anonymity is preserved" is vague — does it mean the ballot has no voter ID, or that the link is encrypted? | Clarified: ballot records only candidate choice; voter ID is never stored in ballot |
| D-02 | NFR-01 (Integrity) | **Non-verifiability** | "Append-only" is an implementation detail, not a verifiable formal property without defining the ballot set formally | Resolved via Z invariant: `Ballots' ⊇ Ballots` (ballots only grow) |
| D-03 | FR-07 (View Results) | **Incompleteness** | No requirement specifies who can view results before tallying is complete | Added: only Auditor can view; only in TALLIED state |
| D-04 | NFR-04 (Completeness) | **Inconsistency** | NFR-04 says "every ballot counted" but FR-06 says "vote counts per candidate" — what if a voter spoils a ballot? | Resolved: spoiled ballots not in scope; all cast ballots are valid |
| D-05 | FR-03 (Open Election) | **Ambiguity** | "At least 1 voter and 1 candidate" — does the voter need to be verified/approved, or just registered? | Clarified: registered = eligible; no separate approval step |

---

## 8. Glossary

| Symbol | Meaning |
|--------|---------|
| `ℙ S` | Power set of S (set of all subsets) |
| `dom f` | Domain of function/relation f |
| `ran f` | Range of function/relation f |
| `∀` | For all |
| `∃` | There exists |
| `⟹` | Implies |
| `#S` | Cardinality (size) of set S |
| `Δ` | Operation that changes state (Z notation) |
| `Ξ` | Operation that does not change state (Z notation) |
| `pre` | Pre-condition (VDM) |
| `post` | Post-condition (VDM) |
| `sig` | Signature — type definition (Alloy) |
| `assert` | Property to verify (Alloy) |
