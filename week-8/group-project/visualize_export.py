import os
from datetime import datetime

import pandas as pd
import plotly.express as px


def create_weekly_chart(df_weekly):
    fig = px.line(
        df_weekly,
        x="week",
        y="revenue",
        title="Nädalane tulu"
    )
    return fig


def create_kpi_summary(kpis):
    from plotly.subplots import make_subplots
    import plotly.graph_objects as go

    fig = make_subplots(
        rows=1,
        cols=3,
        specs=[[{"type": "indicator"}, {"type": "indicator"}, {"type": "indicator"}]]
    )

    fig.add_trace(
        go.Indicator(
            mode="number",
            value=kpis["total_revenue"],
            title={"text": "Total Revenue"}
        ),
        row=1,
        col=1
    )

    fig.add_trace(
        go.Indicator(
            mode="number",
            value=kpis["unique_customers"],
            title={"text": "Unique Customers"}
        ),
        row=1,
        col=2
    )

    fig.add_trace(
        go.Indicator(
            mode="number",
            value=kpis["avg_order_value"],
            title={"text": "Average Order Value"}
        ),
        row=1,
        col=3
    )

    fig.update_layout(title="Peamised KPI-d")

    return fig


def export_results(df, output_dir):
    os.makedirs(output_dir, exist_ok=True)

    date_str = datetime.now().strftime("%Y%m%d")

    csv_path = os.path.join(
        output_dir,
        f"results_{date_str}.csv"
    )

    df.to_csv(csv_path, index=False)

    return csv_path

if __name__ == "__main__":
    os.makedirs("output", exist_ok=True)

    test_data = pd.DataFrame({
        "week": ["2026-08-03", "2026-08-10", "2026-08-17"],
        "revenue": [1200, 1800, 1500]
    })

    test_kpis = {
        "total_revenue": 4500,
        "unique_customers": 120,
        "avg_order_value": 37.50
    }

    weekly_chart = create_weekly_chart(test_data)
    weekly_chart.write_html("output/weekly_revenue.html")

    kpi_chart = create_kpi_summary(test_kpis)
    kpi_chart.write_html("output/kpi_summary.html")

    csv_path = export_results(test_data, "output")

    print("CSV salvestatud:", csv_path)
    print("Diagrammid salvestatud output/ kausta.")
