# Secure Voting System — SVV Lab Project

**Course:** Software Verification & Validation (SVV) Lab  
**System:** Secure Voting System  
**Pipeline:** Requirement Engineering → Z Notation → VDM → Alloy → Validation

---

## Team Members

| Name | Roll No |
|------|---------|
| ABDUL WAHAB | 037 |
| DANIAL ZULFIQAR | 022 |

---

## System Overview

The **Secure Voting System** ensures that:
- Only **registered, eligible voters** can cast a ballot
- Each voter can cast a ballot **exactly once**
- Votes remain **anonymous** — a vote cannot be traced back to its voter
- The election result is **tamper-proof** and auditable

---

## Repository Structure

```
/svv-voting-project
│
├── /requirements
│   ├── SRS.md                    ← Software Requirements Specification
│   └── defect-taxonomy.md        ← Requirement defects classification
│
├── /z-model
│   └── voting-system.tex         ← Z Notation formal model (Z-Editor / CZT)
│
├── /vdm-spec
│   └── VotingSystem.vdmsl        ← VDM-SL specification (Overture)
│
├── /alloy-model
│   └── voting.als                ← Alloy relational model + assertions
│
├── /validation
│   ├── validation-checklist.md   ← Requirement → test mapping
│   └── security-report.md        ← OWASP ZAP scan summary
│
├── /ci-pipeline
│   └── ci-evidence.md            ← GitHub Actions CI run evidence
│
├── /.github/workflows
│   └── ci.yml                    ← GitHub Actions CI workflow
│
└── README.md
```

---

## SVV Pipeline Summary

| Phase | Tool | Key Deliverable |
|-------|------|----------------|
| Requirement Engineering | Git, GitHub Issues | SRS + defect table |
| Formal Modeling | Z-Editor (CZT) | State, invariants, operations |
| Functional Specification | Overture (VDM-SL) | Pre/post conditions |
| Structural Verification | Alloy Analyzer | Counterexample analysis |
| Validation & CI | GitHub Actions, OWASP ZAP | CI pipeline + security scan |

---

## How to Run

### Z Model
1. Install [Community Z Tools (CZT)](http://czt.sourceforge.net/)
2. Open `z-model/voting-system.tex` in Z-Editor
3. Run type-checker

### VDM Spec
1. Install [Overture IDE](https://www.overturetool.org/)
2. Open `vdm-spec/VotingSystem.vdmsl`
3. Run → Proof Obligation Generation

### Alloy Model
1. Download [Alloy Analyzer](https://alloytools.org/)
2. Open `alloy-model/voting.als`
3. Click **Check** to verify assertions

---

## Submission Deadline
**17 May 2026**
