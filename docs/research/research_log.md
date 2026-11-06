# Phase 0 — Research Log

**Course:** INSY 8311 — Database Development with PL/SQL  
**Instructor:** Eric Maniraguha  
**Student:** BYISHIMO NGOGA Blaise — 29359  
**Date:** 6 November 2026

## Proposed project

**Title:** SACCO Collateral and Guarantor Exposure Monitor (SCGEM)

**Problem statement:** SACCOs rely heavily on guarantors and collateral, but coverage is often tracked in spreadsheets, paper files, or not at all. Credit officers cannot easily see whether a loan is adequately covered, whether a guarantor is over-exposed, or why an approval was rejected. This project will build an Oracle database with PL/SQL rules that compute guarantee and collateral coverage, block under-covered loan approvals, and log every decision for audit.

**Planned innovation:** An interactive Power BI dashboard connected live to the Oracle database, showing guarantee coverage, default rates by collateral type, and high-risk/under-covered loans.

## Research log

| # | Source (APA) | Type | Link | Key finding | Gap it shows |
|---|---|---|---|---|---|
| 1 | Jack, W., Kremer, M., de Laat, J., & Suri, T. (2016). *Borrowing requirements, credit access, and adverse selection: Evidence from Kenya* (NBER Working Paper No. 22686). National Bureau of Economic Research. | Research paper | https://doi.org/10.3386/w22686 | Under a Kenyan SACCO's standard terms (one-third deposit plus two-thirds guarantors), only 2.4% of farmers took a loan. When the same loan could be collateralised by the purchased asset, take-up rose to 41.9%, with no repossessions at 75% asset collateral and only 0.7% at 96%. | Guarantor-heavy requirements can exclude creditworthy borrowers. SACCOs need better collateral/guarantee coverage tracking and alternative coverage rules instead of blanket guarantor demands. |
| 2 | Mazimpaka, R., Nizeyimana, P., Kumar, K., Mukwende, P., & Nshimiyimana, J. (2025). Loan risk assessment for Umurenge SACCO using machine learning. *International Journal of Innovative Science and Research Technology*. | Research paper | https://ijisrt.com/assets/upload/files/IJISRT25AUG218.pdf | Using 2,000 anonymised loan-application records from the Rwanda Cooperative Agency (2020–2022), XGBoost reached 89.5% accuracy; credit score, past repayment behaviour, and monthly income were the strongest default predictors. | The study produces a predictive model, not an operational database that enforces collateral/guarantee rules, monitors exposure, or audits rejected approvals. |
| 3 | Omondi Nyayiera, K., & Muchiri, R. (2023). Effect of loan management practices on non-performing loans for deposit taking savings and credit cooperative societies in Kenya. *International Journal of Current Aspects in Finance, Banking and Accounting, 5*(3), 14–28. | Research paper | https://doi.org/10.35942/4fjhrg83 | Across 44 deposit-taking SACCOs in Nairobi County, credit scoring, guarantorship requirements, and repayment enforcement had a negative but statistically insignificant effect on non-performing loans; the authors call for stronger, SACCO-specific NPL frameworks. | Guarantor requirements alone do not solve NPLs. SACCOs need integrated monitoring of guarantee coverage, exposure concentration, and repayment behaviour rather than standalone policies. |
| 4 | FSD Kenya. (2025). *SACCO sub-sector report: Lessons from FinAccess surveys*. Financial Sector Deepening Kenya. | Report / statistic | https://www.fsdkenya.org/wp-content/uploads/2026/01/SACCO-Subsector-Report-Lessons-from-FinAccess-Surveys.pdf | Kenya had 356 regulated SACCOs, Kshs 1.08 trillion in assets, and 7.39 million members in 2024. Guarantors are the most common collateral: their use rose from 42.76% in 2019 to 53.52% in 2024. 75.1% of members who reported a financial loss blamed internal fraud. | Heavy reliance on guarantors coexists with fraud and transparency weaknesses. SACCOs need systematic guarantee registers, coverage checks, and auditable approval trails. |
| 5 | Hermanns, B., Johnson, I., Weißer, S., & Winkler, F. (2017). *Improving on non-performing loans in the microfinance sector of Rwanda*. Sparkassenstiftung für internationale Kooperation. | Report / study (Rwanda context) | https://www.sparkassenstiftung.de/fileadmin/Sparkassenstiftung/downloads/Schriftenreihe/Rwanda_Masterthesis2017_Hermanns_Weisser_Johnson_Winkler_nonperforming_loans_RW.pdf | Rwanda's microfinance NPL ratio was above 10% (up to 46%) against the National Bank of Rwanda's 5% target. The study identifies weak staff/client education, non-standard loan processes, and the absence of core banking and fraud-proof collateral evaluation as structural shortfalls. | Manual, non-standard collateral evaluation and weak systemisation are major causes of NPLs. A database that standardises collateral/guarantee checks and records decisions directly addresses this gap. |
| 6 | SaccoWorks. (n.d.). *Features: FOSA, BOSA & loan management modules*. eLivecode Solutions Limited. | Existing system | https://saccoworks.co.ke/features/ | A commercial SACCO platform advertises guarantor management, collateral valuation, lien management, arrears tracking, and KPI dashboards. | It is a commercial full-suite product. The public feature list does not show database-level enforcement of guarantee coverage thresholds or an open, auditable PL/SQL rule layer that a small SACCO can adapt. |
| 7 | Wanyonyi, M. (2026). *SACCO loan data for women entrepreneurs in Kenya (2015–2025)* [Data set]. Zenodo. | Dataset | https://doi.org/10.5281/zenodo.18912903 | 4,850 anonymised SACCO loan records from women-owned micro-enterprises in Kenya (2015–2025), licensed CC BY 4.0. The workbook includes loan amount, collateral type, savings balance, credit history, group characteristics, default status, and days past due. | The file records collateral type but not guarantor identities or pledged amounts, so the project must model guarantee coverage at loan level and use savings balance as the pledge proxy. Missing values (notably 1,226 blank collateral-type cells) must be handled in Phase II. |
| 8 | Oracle. (n.d.). *Using triggers*. Oracle Database 19c Development Guide. | Technical source | https://docs.oracle.com/en/database/oracle/oracle-database/19/tdddg/using-triggers.html | Oracle triggers are stored PL/SQL units that fire automatically when specified DML events occur. They can enforce complex business rules and security checks inside the database. | Not a gap: this is the technical basis. The project will use `BEFORE INSERT/UPDATE` triggers to block loans whose guarantee/collateral coverage falls below policy and to write audit records. |

## Source mix check

| Required source type | Covered by |
|---|---|
| Research papers (at least 2) | Sources 1, 2, 3 |
| Report or statistic (at least 1) | Sources 4, 5 |
| Existing system (at least 1) | Source 6 |
| Dataset (at least 1) | Source 7 |
| Technical source (at least 1) | Source 8 |
| **Total** | **8 credible sources** |

## Dataset audit note

I downloaded and inspected the dataset (`data/sacco_loan.xlsx`) on 6 November 2026.

- **Size:** 4,850 data rows × 33 columns (908 KB).
- **Licence:** Creative Commons Attribution 4.0 International (CC BY 4.0).
- **Target variable:** `Loan_Default_Status` — 4,000 defaulted (1) and 850 non-defaulted (0), an 82.5% default rate.
- **Collateral types:** Guarantor = 1,263; Group Guarantee = 1,190; Land = 1,171; blank = 1,226 (25.3%).
- **Other missing values:** `Education_Level` has 499 blanks.
- **Useful fields for this project:** `Loan_Amount_KES`, `Savings_Balance_KES`, `Savings_Rate_KES`, `Loan_Term_Months`, `Interest_Rate`, `Credit_History`, `Previous_Loans_Count`, `Collateral_Type`, `Group_Size`, `Group_Composition`, `Sanction_Strength`, `Days_Past_Due`, `Loan_Default_Status`.
- **Data-quality note:** The Zenodo description lists 36 variables, but the downloaded workbook has 33 columns; for example, `Group_Composition` and `Sanction_Strength` appear in the file instead of the described `Group_Cohesion_Score` and `Peer_Pressure_Index`. The codebook must be reconciled before Phase II.
- **No personal identifiers** were found (no names, phone numbers, or ID numbers).

## Search trail

The sources above were found through Google Scholar/general web search and verified by opening the source pages or PDFs:

- `SACCO loan repayment delinquency research paper Rwanda Kenya microfinance`
- `guarantor collateral risk SACCO microcredit research paper`
- `SACCO loan dataset Kaggle microfinance loan records`
- `existing SACCO management system software features`
- `SACCO Sub-Sector Report Lessons from FinAccess Surveys`
- `Oracle Database 19c Using Triggers documentation`

## Problem justification (synthesis)

The evidence points to one practical gap: SACCOs depend on guarantors and collateral, but the check is often manual, inconsistent, and poorly recorded. Existing studies measure default risk or evaluate credit policy, and commercial SACCO systems advertise guarantor and collateral modules, but there is little evidence of a small, open, database-level rule engine that (a) computes guarantee/collateral coverage for each loan, (b) blocks approvals below a policy threshold, and (c) keeps an auditable trail of every decision. SCGEM addresses that gap with Oracle PL/SQL procedures, functions, cursors, packages, triggers, and an audit log, plus a live dashboard for credit officers.

## Full APA references

Hermanns, B., Johnson, I., Weißer, S., & Winkler, F. (2017). *Improving on non-performing loans in the microfinance sector of Rwanda*. Sparkassenstiftung für internationale Kooperation. https://www.sparkassenstiftung.de/fileadmin/Sparkassenstiftung/downloads/Schriftenreihe/Rwanda_Masterthesis2017_Hermanns_Weisser_Johnson_Winkler_nonperforming_loans_RW.pdf

Jack, W., Kremer, M., de Laat, J., & Suri, T. (2016). *Borrowing requirements, credit access, and adverse selection: Evidence from Kenya* (NBER Working Paper No. 22686). National Bureau of Economic Research. https://doi.org/10.3386/w22686

Mazimpaka, R., Nizeyimana, P., Kumar, K., Mukwende, P., & Nshimiyimana, J. (2025). Loan risk assessment for Umurenge SACCO using machine learning. *International Journal of Innovative Science and Research Technology*. https://ijisrt.com/assets/upload/files/IJISRT25AUG218.pdf

Omondi Nyayiera, K., & Muchiri, R. (2023). Effect of loan management practices on non-performing loans for deposit taking savings and credit cooperative societies in Kenya. *International Journal of Current Aspects in Finance, Banking and Accounting, 5*(3), 14–28. https://doi.org/10.35942/4fjhrg83

Oracle. (n.d.). *Using triggers*. Oracle Database 19c Development Guide. https://docs.oracle.com/en/database/oracle/oracle-database/19/tdddg/using-triggers.html

SaccoWorks. (n.d.). *Features: FOSA, BOSA & loan management modules*. eLivecode Solutions Limited. https://saccoworks.co.ke/features/

Wanyonyi, M. (2026). *SACCO loan data for women entrepreneurs in Kenya (2015–2025)* [Data set]. Zenodo. https://doi.org/10.5281/zenodo.18912903
