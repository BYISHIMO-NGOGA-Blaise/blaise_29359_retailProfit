# Phase 0 — Research Log

**Course:** INSY 8311 — Database Development with PL/SQL  
**Instructor:** Eric Maniraguha  
**Student:** BYISHIMO NGOGA Blaise — 29359  
**Date:** 6 November 2026

## Proposed project

**Title:** CampaignGuard — Bank Campaign Contact Compliance and Conversion Tracker

**Problem statement:** Banks run outbound telemarketing campaigns for deposits and loans, but contact history, consent, and frequency limits are often scattered across spreadsheets and CRM notes. This causes over-contact, calls outside permitted windows, missing consent records, and weak conversion analysis. CampaignGuard will be an Oracle database with PL/SQL rules that record customers, campaigns, consent, and every contact attempt; block and log non-compliant attempts; and show conversion performance by customer segment.

**Planned innovation:** An interactive Power BI dashboard connected live to Oracle views, showing conversion rates by job, education, channel, and contact frequency; blocked attempts; consent status; and campaign performance over time.

## Research log

| # | Source (APA) | Type | Link | Key finding | Gap it shows |
|---|---|---|---|---|---|
| 1 | Moro, S., Cortez, P., & Rita, P. (2014). A data-driven approach to predict the success of bank telemarketing. *Decision Support Systems, 62*, 22–31. | Research paper | https://doi.org/10.1016/j.dss.2014.03.001 | Uses 41,188 records from a Portuguese bank's telephone campaigns (May 2008–November 2010) and shows that customer, campaign, and economic variables can predict term-deposit subscription. Call duration, previous campaign outcome, and economic indicators are strong predictors. | The study is a predictive modelling exercise. It does not provide an operational database that enforces consent, contact-frequency limits, or permitted contact windows, nor an auditable contact log. |
| 2 | Dadras, P., & Hoseini, S. S. (2026). Identifying contact fatigue and determining the optimal contact threshold in bank telemarketing campaigns using machine learning and model interpretability. *Journal of Advertising and Sales Management, 7*(2). | Research paper | https://asm.pgu.ac.ir/article_741761_6ad967dfb077c5a720de2174dcc646c8.pdf?lang=en | Conversion falls from 13.19% for customers receiving 1–2 calls to 10.34% for 3–4 calls and 6.41% for 5 or more calls. The authors recommend two calls as a practical operational limit for most customers and a third call only for high-probability prospects. | Banks need a database-level frequency cap and a record of blocked over-contact attempts. A prediction model alone does not enforce the limit or preserve an audit trail. |
| 3 | Elsalamony, H. A. (2014). Bank direct marketing analysis of data mining techniques. *International Journal of Computer Applications, 85*(7), 12–22. | Research paper | https://doi.org/10.5120/14852-3218 | Compares MLPNN, TAN, logistic regression, and C5.0 on real bank deposit-subscription data. The models can identify the customer characteristics that affect campaign success. | The focus is on comparing classifiers, not on operational campaign governance. The paper does not model consent, contact windows, frequency policies, or audit requirements. |
| 4 | European Data Protection Board. (2020). *Guidelines 05/2020 on consent under Regulation 2016/679*. | Report / regulatory guideline | https://www.edpb.europa.eu/our-work-tools/our-documents/guidelines/guidelines-052020-consent-under-regulation-2016679_en | Consent must be freely given, specific, informed, and unambiguous. Silence, pre-ticked boxes, and inactivity do not constitute consent, and consent can be withdrawn. | Banks need a database-level consent register and an audit trail that can prove when consent was given, for which channel, and when it was withdrawn. |
| 5 | World Bank. (2022). *Global Findex Database 2021: Financial inclusion, digital payments, and resilience in the age of COVID-19*. | Report / statistic | https://www.worldbank.org/en/publication/globalfindex | 76% of adults worldwide had an account in 2021, up from 68% in 2017; in Sub-Saharan Africa, 55% of adults had an account, with mobile money driving much of the growth. | As account ownership and outreach grow, banks run more outbound campaigns. This increases the risk of non-compliant contact and makes a consent/frequency audit system more important. |
| 6 | Salesforce. (n.d.). *Financial Services Cloud*. | Existing system | https://www.salesforce.com/financialservices/ | A commercial banking CRM that provides customer profiles, campaign management, analytics, and consent/preference management across the Salesforce platform. | It is a proprietary full-suite platform. Public materials do not expose a small, open, database-level PL/SQL rule layer that a small bank or a student project can inspect, adapt, and audit. |
| 7 | Moro, S., Rita, P., & Cortez, P. (2014). *Bank marketing* [Data set]. UCI Machine Learning Repository. | Dataset | https://doi.org/10.24432/C5K306 | 41,188 anonymised records and 20 input features from a Portuguese bank's phone campaigns, including customer demographics, contact channel, campaign contacts, previous outcomes, and economic indicators. Licensed CC BY 4.0. | The dataset has no customer IDs, exact dates, or consent flags. The project must derive surrogate customer IDs and a chronological contact sequence, and add consent/policy tables with a documented simulation for Phase II. |
| 8 | Oracle. (n.d.). *Using triggers*. Oracle Database 19c Development Guide. | Technical source | https://docs.oracle.com/en/database/oracle/oracle-database/19/tdddg/using-triggers.html | Oracle triggers are stored PL/SQL units that fire automatically on specified DML events. They can enforce complex business rules and security checks inside the database. | Not a gap: this is the technical basis. The project will use `BEFORE INSERT` triggers on contact attempts to enforce consent, frequency caps, and contact windows, and to write audit records. |

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

I downloaded and inspected the UCI Bank Marketing dataset on 6 November 2026. The file used is `bank-additional-full.csv` from `bank-additional.zip`.

- **Size:** 41,188 data rows × 21 columns (5.8 MB).
- **Licence:** Creative Commons Attribution 4.0 International (CC BY 4.0).
- **Period:** May 2008–November 2010, ordered by contact date.
- **Target variable:** `y` — 4,640 subscribed (11.3%) and 36,548 did not subscribe (88.7%). This is an imbalanced target.
- **Unknown values:** `default` 8,597; `education` 1,731; `housing` 990; `loan` 990; `job` 330; `marital` 80. "unknown" is the missing-value marker; there are no blank cells.
- **Contact channel:** cellular 26,144; telephone 15,044.
- **Current-campaign contacts:** minimum 1, maximum 56, average 2.57; 7,635 records have more than 3 contacts and 3,385 have more than 5.
- **Useful fields for this project:** `age`, `job`, `marital`, `education`, `default`, `housing`, `loan`, `contact`, `month`, `day_of_week`, `duration`, `campaign`, `pdays`, `previous`, `poutcome`, `emp.var.rate`, `cons.price.idx`, `cons.conf.idx`, `euribor3m`, `nr.employed`, `y`.
- **Leakage note:** `duration` is known only after the call, so it must not be used to decide whether a customer may be contacted. It will be used only for post-call analysis.
- **No personal identifiers** were found (no names, phone numbers, or national ID numbers).
- **Limitations:** no customer ID, exact date, or consent flag. In Phase II I will assign a surrogate `customer_id` to each record, reconstruct a chronological contact sequence from the file order and the month column, and create a `consent` table seeded with documented simulated consent values for demonstration.

## Search trail

The sources above were found through Google Scholar and general web search, then verified by opening the source pages or PDFs:

- `bank telemarketing conversion contact frequency research paper`
- `bank telemarketing contact fatigue optimal contact threshold`
- `UCI Bank Marketing dataset 222`
- `GDPR consent marketing guidelines EDPB`
- `World Bank Global Findex 2021 account ownership`
- `existing bank CRM campaign consent management features`
- `Oracle Database 19c Using Triggers documentation`

## Problem justification (synthesis)

The evidence points to a practical gap. Bank telemarketing can predict which customers are likely to subscribe, but prediction is not enough: repeated calls quickly reduce conversion, and regulators require explicit, withdrawable consent. Existing commercial CRM suites offer campaign and consent features, but they are large proprietary products. There is little evidence of a small, open, database-level rule engine that (a) checks consent and contact policy before a call, (b) enforces a frequency cap and permitted contact window, (c) blocks and logs non-compliant attempts, and (d) keeps an auditable trail. CampaignGuard addresses that gap with Oracle PL/SQL functions, procedures, cursors, packages, triggers, and an audit log, plus a live Power BI dashboard for campaign managers.

## Full APA references

Dadras, P., & Hoseini, S. S. (2026). Identifying contact fatigue and determining the optimal contact threshold in bank telemarketing campaigns using machine learning and model interpretability. *Journal of Advertising and Sales Management, 7*(2). https://asm.pgu.ac.ir/article_741761_6ad967dfb077c5a720de2174dcc646c8.pdf?lang=en

Elsalamony, H. A. (2014). Bank direct marketing analysis of data mining techniques. *International Journal of Computer Applications, 85*(7), 12–22. https://doi.org/10.5120/14852-3218

European Data Protection Board. (2020). *Guidelines 05/2020 on consent under Regulation 2016/679*. https://www.edpb.europa.eu/our-work-tools/our-documents/guidelines/guidelines-052020-consent-under-regulation-2016679_en

Moro, S., Cortez, P., & Rita, P. (2014). A data-driven approach to predict the success of bank telemarketing. *Decision Support Systems, 62*, 22–31. https://doi.org/10.1016/j.dss.2014.03.001

Moro, S., Rita, P., & Cortez, P. (2014). *Bank marketing* [Data set]. UCI Machine Learning Repository. https://doi.org/10.24432/C5K306

Oracle. (n.d.). *Using triggers*. Oracle Database 19c Development Guide. https://docs.oracle.com/en/database/oracle/oracle-database/19/tdddg/using-triggers.html

Salesforce. (n.d.). *Financial Services Cloud*. https://www.salesforce.com/financialservices/

World Bank. (2022). *Global Findex Database 2021: Financial inclusion, digital payments, and resilience in the age of COVID-19*. https://www.worldbank.org/en/publication/globalfindex
