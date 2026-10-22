
**Dashboard (Power BI)**
- Page 1: KPIs and attrition rate by department, job role, age group and overtime, with slicers synced to page 2.
- Page 2: attrition rate by work-life balance, job, relationship and environment satisfaction, training, experience, income group, plus HR recommendations.

## Limitations
- The dataset is fictional sample data, so findings show methods, not real company results.
- It has no dates, so trends over time cannot be analysed.
- Findings are associations, not proven causes (for example overtime goes with leaving, but this data cannot prove it causes it).
- The test set has only 47 leavers, so model metrics move by a few points with a different split. Some groups are small (Sales Representatives: 83 employees).

## How to run
1. Install: `pip install pandas numpy matplotlib seaborn scikit-learn sqlalchemy psycopg2-binary`.
2. Set your PostgreSQL password as an environment variable `PG_PASSWORD` (the notebook skips the database load if it is not set).
3. Run `employee_attrition_analysis.ipynb` from top to bottom.
4. Run the SQL queries in pgAdmin or any SQL client.
5. Open `hr_analytics_dashboard.pbix` in Power BI Desktop.


