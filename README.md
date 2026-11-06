# CampaignGuard — Bank Campaign Contact Compliance and Conversion Tracker

**Student:** BYISHIMO NGOGA Blaise — **29359**  
**Course:** INSY 8311 — Database Development with PL/SQL  
**Instructor:** Eric Maniraguha  
**Academic year:** 2026–2027, Semester I  
**Phase:** 0 — Research, data source, and project proposal

## Problem statement

Banks run outbound telemarketing campaigns for deposits and loans, but contact history, consent, and frequency limits are often scattered across spreadsheets and CRM notes. This causes over-contact, calls outside permitted windows, missing consent records, and weak conversion analysis. CampaignGuard will be an Oracle database with PL/SQL rules that record customers, campaigns, consent, and every contact attempt; block and log non-compliant attempts; and show conversion performance by customer segment.

## Objectives

**Main objective:** Design and implement an Oracle database with PL/SQL that enforces bank campaign contact compliance and tracks conversion performance.

**Specific objectives:**

1. Model customers, campaigns, consent, contact attempts, conversions, contact policies, and audit events in third normal form (3NF).
2. Load and validate the UCI Bank Marketing dataset, handle "unknown" values, derive surrogate customer IDs, and reconstruct a chronological contact sequence.
3. Develop PL/SQL functions, procedures, cursors, packages, and triggers that check consent, enforce frequency caps and permitted contact windows, block non-compliant attempts, and write audit records.
4. Build a live Power BI dashboard connected to Oracle views that shows conversion rates by segment, contact frequency, blocked attempts, and consent status.
5. Document the system and demonstrate it live in the final presentation.

## Data source

- **Dataset:** *Bank Marketing*
- **Authors:** Sérgio Moro, Paulo Rita, and Paulo Cortez (2014)
- **Repository:** UCI Machine Learning Repository — https://doi.org/10.24432/C5K306
- **File used:** `bank-additional-full.csv` from `bank-additional.zip`
- **Licence:** Creative Commons Attribution 4.0 International (CC BY 4.0)
- **Size:** 41,188 anonymised records × 21 columns
- **Period:** May 2008–November 2010, ordered by contact date
- **Target:** `y` — 4,640 subscribed (11.3%) and 36,548 did not subscribe (88.7%)
- **Key fields:** `age`, `job`, `marital`, `education`, `default`, `housing`, `loan`, `contact`, `month`, `day_of_week`, `duration`, `campaign`, `pdays`, `previous`, `poutcome`, `emp.var.rate`, `cons.price.idx`, `cons.conf.idx`, `euribor3m`, `nr.employed`, `y`
- **Privacy:** no names, phone numbers, or national ID numbers are present.
- **Local copy:** `data/bank-additional-full.csv`

The dataset has no customer IDs, exact dates, or consent flags. In Phase II I will assign a surrogate `customer_id` to each record, reconstruct a chronological contact sequence from the file order and the month column, and create a `consent` table seeded with documented simulated consent values for demonstration. The `duration` field is known only after a call, so it will not be used to decide whether a customer may be contacted.

## Innovation

**Option:** Analytics dashboard  
**Tool:** Power BI, connected live to the Oracle database.

Power BI will read Oracle views backed by PL/SQL functions and show:

- conversion rate by job, education, channel, and contact frequency;
- customers contacted above the policy limit;
- blocked attempts by reason (no consent, frequency cap, outside window);
- campaign performance over time and by customer segment;
- consent status and withdrawal trends.

Business rules remain in PL/SQL; Power BI only displays and filters the results.

## Planned database tables

| Table | Purpose |
|---|---|
| `customers` | Anonymised customer profile and contact preferences. |
| `campaigns` | Campaign name, product, dates, target segment, status, and contact policy. |
| `consent` | Customer consent per channel, consent date, source, expiry date, and withdrawal date. |
| `contact_attempts` | Every attempted contact, channel, timestamp, outcome, duration, blocked flag, and block reason. |
| `conversions` | Term-deposit subscription outcome linked to the successful contact attempt. |
| `contact_policies` | Maximum contacts per day/week, permitted contact window, and channel rules. |
| `market_conditions` | Economic indicators by period for campaign timing analysis. |
| `audit_log` | Every consent change, blocked attempt, approval, and sensitive update with user, timestamp, and reason. |
| `jobs` | Lookup table for occupation categories. |
| `education_levels` | Lookup table for education categories. |
| `contact_channels` | Lookup table for cellular, telephone, and other channels. |
| `campaign_outcomes` | Lookup table for contact and conversion outcomes. |

### Key relationships

- One `customer` has many `consent` records and many `contact_attempts`.
- One `campaign` has many `contact_attempts` and many `conversions`.
- One successful `contact_attempt` can produce one `conversion`.
- `contact_policies` are applied by channel and campaign.
- `audit_log` records changes to consent, contact attempts, and conversions.

## Planned PL/SQL features

| Feature | Planned use |
|---|---|
| Function `fn_contacts_last_n_days` | Counts a customer's contacts in the last 1, 7, or 30 days by channel. |
| Function `fn_is_contact_allowed` | Returns an allowed/blocked status with a reason after checking consent, frequency cap, contact window, and campaign status. |
| Procedure `prc_set_consent` | Records consent, renewal, or withdrawal and writes an audit entry. |
| Procedure `prc_log_contact_attempt` | Calls the compliance check, inserts the attempt, or stores a blocked attempt with a reason. |
| Procedure `prc_record_conversion` | Records a successful subscription and updates campaign metrics. |
| Cursor `cur_high_frequency_customers` | Lists customers contacted above the policy threshold for review. |
| Package `pkg_campaign_compliance` | Groups the consent, frequency, window, and conversion logic. |
| Trigger `trg_contact_attempt_guard` | `BEFORE INSERT` trigger that blocks non-compliant contact attempts. |
| Trigger `trg_audit_consent` | Logs every consent insert, update, and withdrawal. |
| Views `vw_campaign_conversion`, `vw_blocked_attempts`, `vw_contact_frequency`, `vw_consent_status` | Feed the Power BI dashboard. |
| Exception handling | Custom errors for missing consent, frequency-cap breach, outside-window contact, and closed campaign. |
| Scheduler job | Expires consents and refreshes campaign summary views nightly. |

## Repository structure

```
.
├── README.md
├── data/
│   ├── README.md
│   └── bank-additional-full.csv
├── docs/
│   ├── proposal/
│   │   └── registration_row.md
│   ├── research/
│   │   └── research_log.md
│   └── presentation/
└── (later phases: sql/, innovation/, screenshots/)
```

## Phase 0 checklist

- [x] Topic selected in the banking/finance area.
- [x] At least 6 credible sources, including a dataset.
- [x] Real dataset downloaded and audited.
- [ ] Topic registered on the instructor's Google Sheet.
- [x] GitHub repository created and named correctly.
- [ ] Proposal emailed to the instructor with the GitHub link.
- [ ] Presentation uploaded to the repository.

## References

Dadras, P., & Hoseini, S. S. (2026). Identifying contact fatigue and determining the optimal contact threshold in bank telemarketing campaigns using machine learning and model interpretability. *Journal of Advertising and Sales Management, 7*(2). https://asm.pgu.ac.ir/article_741761_6ad967dfb077c5a720de2174dcc646c8.pdf?lang=en

Elsalamony, H. A. (2014). Bank direct marketing analysis of data mining techniques. *International Journal of Computer Applications, 85*(7), 12–22. https://doi.org/10.5120/14852-3218

European Data Protection Board. (2020). *Guidelines 05/2020 on consent under Regulation 2016/679*. https://www.edpb.europa.eu/our-work-tools/our-documents/guidelines/guidelines-052020-consent-under-regulation-2016679_en

Moro, S., Cortez, P., & Rita, P. (2014). A data-driven approach to predict the success of bank telemarketing. *Decision Support Systems, 62*, 22–31. https://doi.org/10.1016/j.dss.2014.03.001

Moro, S., Rita, P., & Cortez, P. (2014). *Bank marketing* [Data set]. UCI Machine Learning Repository. https://doi.org/10.24432/C5K306

Oracle. (n.d.). *Using triggers*. Oracle Database 19c Development Guide. https://docs.oracle.com/en/database/oracle/oracle-database/19/tdddg/using-triggers.html

Salesforce. (n.d.). *Financial Services Cloud*. https://www.salesforce.com/financialservices/

World Bank. (2022). *Global Findex Database 2021: Financial inclusion, digital payments, and resilience in the age of COVID-19*. https://www.worldbank.org/en/publication/globalfindex
