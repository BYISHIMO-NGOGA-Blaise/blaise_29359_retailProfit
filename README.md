# SACCO Collateral and Guarantor Exposure Monitor (SCGEM)

**Student:** BYISHIMO NGOGA Blaise — **29359**  
**Course:** INSY 8311 — Database Development with PL/SQL  
**Instructor:** Eric Maniraguha  
**Academic year:** 2026–2027, Semester I  
**Phase:** 0 — Research, data source, and project proposal

## Problem statement

SACCOs rely heavily on guarantors and collateral to secure member loans, but coverage is often tracked in spreadsheets, paper files, or not at all. Credit officers cannot easily see whether a loan is adequately covered, whether a guarantor is over-exposed, or why an approval was rejected. This project will build an Oracle database with PL/SQL rules that compute guarantee and collateral coverage, block under-covered loan approvals, and log every decision for audit.

## Objectives

**Main objective:** Design and implement an Oracle database with PL/SQL that monitors SACCO loan collateral and guarantee coverage and enforces coverage rules.

**Specific objectives:**

1. Model SACCO members, loans, collateral, guarantee exposure, repayments, risk assessments, and audit events in third normal form (3NF).
2. Load and validate the real SACCO loan dataset, resolving missing and inconsistent values.
3. Develop PL/SQL functions, procedures, cursors, packages, and triggers that compute coverage ratios, classify loan risk, block under-covered approvals, and write audit records.
4. Build a live Power BI dashboard connected to Oracle views that show guarantee coverage, default rates by collateral type, and high-risk/under-covered loans.
5. Document the system and demonstrate it live in the final presentation.

## Data source

- **Dataset:** *SACCO Loan Data for Women Entrepreneurs in Kenya (2015–2025)*
- **Author:** Maurice Wanyonyi (2026)
- **Repository:** Zenodo — https://doi.org/10.5281/zenodo.18912903
- **Licence:** Creative Commons Attribution 4.0 International (CC BY 4.0)
- **Size:** 4,850 anonymised loan records × 33 columns
- **Key fields:** `Loan_Amount_KES`, `Savings_Balance_KES`, `Collateral_Type`, `Credit_History`, `Loan_Default_Status`, `Days_Past_Due`, `Group_Size`, `Group_Composition`, `Sanction_Strength`
- **Local copy:** `data/sacco_loan.xlsx`
- **Privacy:** no names, phone numbers, or national IDs are included.

The dataset audit is documented in `docs/research/research_log.md`. It notes 1,226 blank `Collateral_Type` values and 499 blank `Education_Level` values that must be cleaned in Phase II.

## Innovation

**Option:** Analytics dashboard  
**Tool:** Power BI, connected live to the Oracle database.

Power BI will read Oracle views backed by PL/SQL functions and show:

- guarantee and collateral coverage per loan;
- default rates by collateral type;
- high-risk and under-covered loans;
- trends by county, business sector, and loan purpose.

Business rules remain in PL/SQL; Power BI only displays and filters the results.

## Planned database tables

| Table | Purpose |
|---|---|
| `members` | Anonymised SACCO member and business profile. |
| `loans` | Loan amount, term, interest, purpose, status, days past due, and default outcome. |
| `collateral` | Collateral type, estimated value, valuation date, and coverage ratio per loan. |
| `guarantee_exposure` | Guarantee type (individual/group), guaranteed amount, savings pledged, and coverage ratio. |
| `repayments` | Scheduled and actual repayments, due dates, and arrears status. |
| `risk_assessments` | Computed risk score, risk band, coverage ratio, assessment date, and officer. |
| `audit_log` | Every approval, rejection, change, and denied action with user, timestamp, and reason. |
| `collateral_types` | Lookup table for collateral categories. |
| `loan_statuses` | Lookup table for loan lifecycle states. |
| `credit_history_levels` | Lookup table for credit-history ratings. |

### Key relationships

- One `member` has many `loans`.
- One `loan` has one or more `collateral` and `guarantee_exposure` records.
- One `loan` has many `repayments` and many `risk_assessments`.
- `audit_log` records changes to loans, collateral, guarantees, and risk assessments.

## Planned PL/SQL features

| Feature | Planned use |
|---|---|
| Function `fn_coverage_ratio` | Returns `(savings pledged + collateral value) / loan amount` for a loan. |
| Function `fn_risk_score` | Scores a loan using coverage, credit history, days past due, previous loans, and loan-to-savings ratio. |
| Procedure `prc_register_loan` | Validates and inserts a loan with its collateral and guarantee exposure. |
| Procedure `prc_assess_loan` | Computes coverage and risk, then writes a `risk_assessments` row. |
| Procedure `prc_approve_loan` | Approves only if coverage meets policy; otherwise raises a custom exception and logs the denial. |
| Cursor `cur_undercovered_loans` | Lists loans below the coverage threshold for follow-up. |
| Package `pkg_loan_risk` | Groups the coverage, scoring, assessment, and approval logic. |
| Trigger `trg_loan_coverage_guard` | `BEFORE INSERT OR UPDATE` trigger that blocks under-covered loans. |
| Trigger `trg_audit_*` | Writes `audit_log` entries for approvals, rejections, and sensitive changes. |
| Views `vw_loan_coverage`, `vw_default_by_collateral`, `vw_high_risk_loans` | Feed the Power BI dashboard. |
| Exception handling | Custom errors for missing collateral, insufficient coverage, and invalid loan states. |

## Repository structure

```
.
├── README.md
├── data/
│   ├── README.md
│   └── sacco_loan.xlsx
├── docs/
│   ├── proposal/
│   │   └── registration_row.md
│   ├── research/
│   │   └── research_log.md
│   └── presentation/
└── (later phases: sql/, innovation/, screenshots/)
```

## Phase 0 checklist

- [x] Topic selected in the banking/SACCO area.
- [x] At least 6 credible sources, including a dataset.
- [x] Real dataset downloaded and audited.
- [ ] Topic registered on the instructor's Google Sheet.
- [x] GitHub repository created and named correctly.
- [ ] Proposal emailed to the instructor with the GitHub link.
- [ ] Presentation uploaded to the repository.

## References

Hermanns, B., Johnson, I., Weißer, S., & Winkler, F. (2017). *Improving on non-performing loans in the microfinance sector of Rwanda*. Sparkassenstiftung für internationale Kooperation. https://www.sparkassenstiftung.de/fileadmin/Sparkassenstiftung/downloads/Schriftenreihe/Rwanda_Masterthesis2017_Hermanns_Weisser_Johnson_Winkler_nonperforming_loans_RW.pdf

Jack, W., Kremer, M., de Laat, J., & Suri, T. (2016). *Borrowing requirements, credit access, and adverse selection: Evidence from Kenya* (NBER Working Paper No. 22686). National Bureau of Economic Research. https://doi.org/10.3386/w22686

Mazimpaka, R., Nizeyimana, P., Kumar, K., Mukwende, P., & Nshimiyimana, J. (2025). Loan risk assessment for Umurenge SACCO using machine learning. *International Journal of Innovative Science and Research Technology*. https://ijisrt.com/assets/upload/files/IJISRT25AUG218.pdf

Omondi Nyayiera, K., & Muchiri, R. (2023). Effect of loan management practices on non-performing loans for deposit taking savings and credit cooperative societies in Kenya. *International Journal of Current Aspects in Finance, Banking and Accounting, 5*(3), 14–28. https://doi.org/10.35942/4fjhrg83

Oracle. (n.d.). *Using triggers*. Oracle Database 19c Development Guide. https://docs.oracle.com/en/database/oracle/oracle-database/19/tdddg/using-triggers.html

SaccoWorks. (n.d.). *Features: FOSA, BOSA & loan management modules*. eLivecode Solutions Limited. https://saccoworks.co.ke/features/

Wanyonyi, M. (2026). *SACCO loan data for women entrepreneurs in Kenya (2015–2025)* [Data set]. Zenodo. https://doi.org/10.5281/zenodo.18912903
