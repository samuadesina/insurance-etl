# 🛡️ Insurance ETL Pipeline
### Production-Grade Data Engineering | Sam Adesina

> **Simulated client: ShieldGuard Insurance Group** — End-to-end ETL pipeline extracting insurance data from a live PostgreSQL database, applying data quality validation, transformation, and outputting a clean, analysis-ready dataset.

---

## What This Project Does

This is a **fully engineered ETL pipeline** — not a script, a system. It extracts raw insurance data from Supabase (PostgreSQL), validates data quality, applies transformations, and delivers a clean processed dataset ready for downstream analysis.

The pipeline handles **20,004 records across 42 columns** with full logging, null imputation, outlier detection, and metadata tagging at every stage.

---

## Tech Stack

| Layer | Tools |
|---|---|
| **Data Source** | PostgreSQL (Supabase) via SQLAlchemy |
| **Extraction** | Custom SQL query runner + data extractor |
| **Transformation** | Custom `Transformer` class — imputation, type fixing, outlier flagging |
| **Validation** | Custom `Validator` class — null checks, duplicate checks, negative value checks |
| **Orchestration** | `ETLPipeline` — single entry point, full logging |
| **Environment** | Python 3.11, venv, `.env` config |

---

## Project Structure

```
insurance-etl/
├── data/
│   ├── raw/                    # Extracted from Supabase (raw-data.csv)
│   └── processed/              # Cleaned output (processed-data.csv, 20,004 rows)
├── sql/
│   └── extracted_raw_data.sql      # Source extraction query
├── src/
│   ├── data_access/
│   │   ├── data_extractor.py       # Supabase → CSV
│   │   └── query_runner.py         # SQL execution layer
│   └── etl/
│       ├── etl_pipeline.py         # Orchestrator
│       ├── transformer.py          # Feature engineering + imputation
│       └── validator.py            # Data quality checks
├── config.py
├── connection.py
└── run.py                          # Single entry point
```

---

## Pipeline Results

```
Extracted : 20,004 rows × 42 columns
Nulls     : 9 columns flagged → imputed (median / mode strategy)
Duplicates: 0
Outliers  : 331 rows flagged (1.7% of dataset)
Output    : processed-data.csv (7.7 MB)
Status    : PASSED ✓
```

---

## What the Pipeline Does — Step by Step

**Step 1 — Extract**
Connects to Supabase via SQLAlchemy, executes a multi-table SQL join across `claims`, `policies`, `customers`, `agents`, and `risk_assessments`, and writes raw output to `data/raw/raw-data.csv`.

**Step 2 — Validate**
Runs automated data quality checks: row count, null percentages per column, duplicate detection, and negative value flags on financial columns. Produces a pass/fail result with full warnings logged.

**Step 3 — Transform**
- Null imputation: median for numeric columns, `'Unknown'` for categoricals
- Type casting and standardisation
- Outlier flagging via IQR bounds on `claim_id`, `amount_claimed`, `amount_approved`
- `is_any_outlier` composite flag added
- Metadata columns appended: `_industry`, `_processed_at`, `_pipeline_version`

**Step 4 — Load**
Writes 20,004 clean rows to `data/processed/processed-data.csv` with full logging of row count and file size.

---

## How to Run

```bash
# 1. Clone and set up environment
git clone https://github.com/samueladesina/insurance-etl.git
cd insurance-etl
python -m venv insurance-venv
source insurance-venv/bin/activate
pip install -r requirements.txt

# 2. Configure database connection
cp .env.example .env
# Add your DB_URL to .env

# 3. Run the pipeline
python run.py
```

---

## Part of a Larger Portfolio

This is one of several production-grade data engineering projects built end-to-end with a real database, custom pipeline architecture, and domain-specific logic.

| Project | Description |
|---|---|
| [retail-etl](https://github.com/samueladesina/retail-etl) | Retail — full ETL pipeline (PostgreSQL / Supabase) |
| [banking-etl](https://github.com/samueladesina/banking-etl) | Banking — transactions, fraud alerts, loan risk (PostgreSQL) |
| **insurance-etl** | **Insurance — claims, policies, risk assessments (PostgreSQL)** |

---

## Skills Demonstrated

`Python` · `PostgreSQL` · `SQLAlchemy` · `pandas` · `ETL pipeline design` · `data quality validation` · `data transformation` · `Supabase` · `logging` · `environment config`

---

*Built by [Sam Adesina](https://github.com/samueladesina) — MSc Data Science | Open to data engineering and analyst roles.*
