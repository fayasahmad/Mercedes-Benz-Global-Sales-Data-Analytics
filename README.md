# 🏎️ Mercedes-Benz Global Sales Data Analytics
### Strategic Product & Market Analytics (2020–2025)

---

## 📌 Project Overview

An end-to-end data analytics case study examining Mercedes-Benz global vehicle sales performance from 2020 to 2025. The objective was to transform raw sales data into actionable product and market intelligence using:

- **Python** — Exploratory Data Analysis (EDA) & ETL Pipeline
- **SQL Server** — Advanced Business Queries & Trend Analysis
- **Power BI** — Multi-Page Executive Dashboard
- **DAX** — Advanced KPIs, Rankings, YoY Growth & Volatility Metrics

The final deliverable is a structured, consulting-style dashboard focused on **product performance, pricing strategy, EV transition, portfolio concentration, and sales growth stability** across the Mercedes-Benz lineup.

---

## 🎯 Business Objectives

This project answers the following strategic questions:

- Which Mercedes-Benz models are driving overall sales performance?
- Are premium and ultra-luxury models aligned with market demand?
- Does horsepower and turbo configuration influence vehicle sales?
- Is the company becoming increasingly dependent on high-end segments?
- How fast is EV adoption accelerating within the Mercedes-Benz portfolio?
- Which models exhibit stable vs. volatile demand patterns?
- Is overall sales growth consistent on a year-over-year basis?

---

## 🛠️ Tools & Technologies Used

| Tool | Purpose |
|------|---------|
| **Python** (Pandas, Matplotlib) | EDA, Data Cleaning, Feature Engineering |
| **SQL Server** | Business Problem Solving, Ranking, Growth Analysis |
| **Power BI** | Multi-Page Executive Dashboard Development |
| **DAX** | Advanced KPIs, Ranking, YoY Growth, Volatility Calculations |

---

## 🔍 Project Workflow

### 1️⃣ Python — EDA & ETL

- Cleaned and standardized the raw dataset
- Normalized column names and resolved inconsistencies
- Identified and handled duplicates & null values
- Created **price segmentation** categories across the vehicle lineup
- Generated **horsepower buckets** for performance analysis
- Identified demand outliers using the IQR method
- Built preliminary visual insights to guide SQL modeling

> Python ensured clean, analysis-ready data before SQL business logic was applied.

---

### 2️⃣ SQL Server — Business Analysis

Used advanced SQL queries to:

- Rank Mercedes-Benz models by sales volume and total revenue
- Detect pricing misalignment across vehicle segments
- Identify portfolio concentration risk among top-selling models
- Calculate EV growth trends across the product range
- Analyze demand volatility patterns by model and segment
- Solve strategic product positioning questions

**SQL techniques included:**

- Window Functions: `RANK()`, `DENSE_RANK()`, `NTILE()`, `LAG()`
- Aggregations, CTEs, and Subqueries
- Rolling averages and cumulative growth calculations

---

### 3️⃣ Power BI — Strategic Dashboard

Built a **6-page structured executive dashboard**:

---

### 📊 Dashboard Pages

#### 🟢 Page 1 — Executive Overview
- Total Sales KPI
- Estimated Revenue
- Average Base Price
- EV Share %
- Sales Trend (2020–2025)
- Price Category Distribution
- Fuel Type Mix

#### 🟡 Page 2 — Product Performance
- Top 10 Models by Sales
- Bottom 10 Underperforming Models
- Revenue Rank vs. Sales Rank
- Average Price by Model
- Efficiency Gap Analysis

#### 🔵 Page 3 — Feature Impact Analysis
- Turbo % Contribution to Total Sales
- Average Horsepower across Portfolio
- HP Bucket vs. Sales Volume
- Turbo vs. Non-Turbo Comparison
- Fuel Type Trend Over Time

#### 🟣 Page 4 — Pricing Strategy
- Economy vs. Ultra Luxury Segment Share
- Price Category vs. Sales Volume
- Revenue Contribution by Segment
- Price Rank vs. Sales Rank

#### 🟢 Page 5 — EV Transition Analysis
- Total EV Sales
- EV Share % of Portfolio
- EV YoY Growth %
- Peak EV Year Identification
- Fuel Type Transition Trend (2020–2025)

#### 🔴 Page 6 — Growth & Stability
- Total Portfolio Growth % (2020–2025)
- Year-over-Year Growth %
- Most Stable Model Identification
- Model Volatility Analysis
- Growth vs. Decline Comparison Table

---

## 📈 Key Insights

- The portfolio shows **moderate concentration** in top-selling models, with a handful of vehicles driving disproportionate revenue.
- **Premium and Ultra Luxury segments** contribute significantly above their sales volume share in total revenue.
- **EV adoption** demonstrates accelerating year-over-year growth within the Mercedes-Benz lineup.
- Certain models — particularly core sedan and SUV lines — exhibit **stable low-volatility demand patterns**.
- **Turbo configuration** contributes significantly to total sales volume across all price segments.
- **Pricing strategy** is well-aligned with horsepower segmentation, reinforcing a clear performance-to-price positioning.

---

## 📁 Repository Structure

```
mercedes-sales-dashboard/
│
├── data/
│   ├── raw/                        # Original dataset files
│   └── cleaned/                    # Post-ETL analysis-ready data
│
├── python/
│   ├── eda_analysis.ipynb          # Exploratory Data Analysis notebook
│   └── etl_pipeline.py             # Data cleaning & feature engineering script
│
├── sql/
│   └── business_queries.sql        # All SQL Server business analysis queries
│
├── powerbi/
│   └── mercedes-sales_Dashboard.pbix  # Full Power BI dashboard file
│
├── assets/
│   └── screenshots/                # Dashboard page previews
│
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites

- Python 3.9+
- SQL Server 2019+ (or Azure SQL)
- Power BI Desktop (latest version)

### Setup

```bash
# Clone the repository
git clone https://github.com/yourusername/mercedes-sales-dashboard.git

# Navigate to the project folder
cd mercedes-sales-dashboard

# Install Python dependencies
pip install -r requirements.txt

# Run the ETL pipeline
python python/etl_pipeline.py

# Open the EDA notebook
jupyter notebook python/eda_analysis.ipynb
```

> Load `sql/business_queries.sql` into SQL Server Management Studio and execute against your cleaned dataset.  
> Open `powerbi/StarMetrics_Dashboard.pbix` in Power BI Desktop and refresh the data source connection.

---

## 📬 Contact

**Author:** Fayas 
**LinkedIn:** www.linkedin.com/in/fayas-ahmad-834615242  
**GitHub:** https://github.com/fayasahmad

---

> *Built as a portfolio data analytics project demonstrating end-to-end BI development — from raw Mercedes-Benz sales data to executive-level strategic market intelligence.*
