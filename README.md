# Credit Card Portfolio Analytics

An analytics engineering portfolio project using SQL, dbt Core, and DuckDB to demonstrate credit-card transaction reporting, merchant-category analysis, data quality, and financial reconciliation.

## Business Objective

Transform raw credit-card transaction data into reliable reporting datasets that support portfolio monitoring and merchant-spending analysis.

The project demonstrates:

- Monthly purchase volume and transaction activity
- Distinct purchasing accounts
- Average transaction amounts
- Merchant Category Code (MCC) spending patterns
- Automated data-quality and financial reconciliation checks

## Technology Stack

- Python 3.12
- dbt Core 1.12.6
- dbt-duckdb 1.11.1
- DuckDB
- SQL and Git

Primary development environment: Ubuntu Linux.

## Dataset

The project uses 10 synthetic credit-card transactions covering January through March 2026.

Fields include transaction ID, account ID, transaction date, merchant name, MCC, and transaction amount.

The sample dataset contains no actual customer transactions or real cardholder account numbers.

**Limitation:** The small synthetic dataset demonstrates transformation logic and testing. It is not sufficient for meaningful statistical inference or production-scale performance benchmarking.

## Data Pipeline

```text
seeds/credit_card_transactions.csv
               |
               v
    credit_card_transactions
               |
               v
  stg_credit_card_transactions
               |
       +-------+-------+
       |               |
       v               v
monthly_portfolio_  monthly_mcc_
performance         spending
```

## Analytics Models

### stg_credit_card_transactions

Standardizes transaction identifiers, account IDs, transaction dates, merchant names, merchant category codes, and purchase amounts.

Creates a reporting-month field for aggregation.

### monthly_portfolio_performance

Produces monthly portfolio reporting metrics:

- Transaction count
- Total purchase volume
- Distinct purchasing accounts
- Average transaction amount

### monthly_mcc_spending

Produces monthly MCC-level analytics:

- Transaction count
- Purchase volume
- Average transaction amount
- Percentage of monthly portfolio spending

The spending-share calculation uses a SQL window function partitioned by reporting month.

## Data Quality and Reconciliation

The project contains seven automated tests covering:

- Required transaction identifiers
- Unique transaction identifiers
- Required account IDs
- Required transaction amounts
- Positive transaction amounts
- Monthly portfolio reconciliation
- MCC-to-portfolio financial reconciliation

The most recent full project build completed with 11 successful resources and zero errors.

## Sample Results

| Month | Transactions | Purchase Volume |
|---|---:|---:|
| January 2026 | 4 | $876.45 |
| February 2026 | 4 | $1,023.85 |
| March 2026 | 2 | $413.75 |
| **Total** | **10** | **$2,314.05** |

These values represent synthetic demonstration data, not actual financial-services portfolio performance.

## Running the Project

### Prerequisites

- Python 3.12
- Git
- Linux, macOS, or Windows with a compatible Python environment

### 1. Clone the repository

```bash
git clone <repository-url>
cd credit_card_portfolio
```

Replace `<repository-url>` with the published repository URL.

### 2. Create a Python virtual environment

Linux/macOS:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

Windows PowerShell:

```powershell
py -3.12 -m venv .venv
.venv\Scripts\Activate.ps1
```

### 3. Install dependencies

```bash
python -m pip install -r requirements.txt
```

### 4. Configure dbt

The repository includes a credential-free example profile in `profiles.yml.example`.

Linux/macOS:

```bash
mkdir -p ~/.dbt
cp profiles.yml.example ~/.dbt/profiles.yml
```

If an existing profile is present, preserve it and merge the project configuration rather than overwriting it.

For Windows, copy the example profile into the `.dbt` directory in your user home folder and rename it `profiles.yml`.

### 5. Verify and build

```bash
dbt debug
dbt build
```

The build loads the synthetic transaction seed, creates the analytics models, and executes the automated tests.

### 6. Preview results

```bash
dbt show --select monthly_portfolio_performance
dbt show --select monthly_mcc_spending
```

## Repository Structure

```text
credit_card_portfolio/
├── models/
│   ├── staging/
│   │   └── stg_credit_card_transactions.sql
│   └── marts/
│       ├── monthly_portfolio_performance.sql
│       └── monthly_mcc_spending.sql
├── seeds/
│   ├── credit_card_transactions.csv
│   └── schema.yml
├── tests/
│   ├── assert_positive_transaction_amount.sql
│   ├── assert_monthly_portfolio_reconciliation.sql
│   └── assert_mcc_spending_reconciliation.sql
├── dbt_project.yml
├── profiles.yml.example
├── requirements.txt
├── .gitignore
└── README.md
```

Local database files, Python environments, dbt logs, and generated artifacts are excluded from Git tracking.

## Future Enhancements

Potential extensions include:

- Merchant rankings and concentration analysis
- Account and portfolio segmentation
- Loyalty rewards earning and redemption analytics
- Rewards liability and redemption-rate forecasting

## Portfolio Purpose

This project demonstrates modern analytics engineering techniques applied to financial-services reporting: modular SQL transformations, reproducible datasets, dbt dependency management, automated testing, and financial reconciliation.
