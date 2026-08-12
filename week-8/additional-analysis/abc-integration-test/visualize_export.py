import os
from datetime import datetime

import pandas as pd
import plotly.express as px
import plotly.graph_objects as go


def create_weekly_chart(df_weekly, output_dir="output"):
    """Create and save a weekly revenue line chart."""
    os.makedirs(output_dir, exist_ok=True)

    date_str = datetime.now().strftime("%Y%m%d")

    fig = px.line(
        df_weekly,
        x="week",
        y="revenue",
        title="Nädalane tulu"
    )

    fig.write_html(
        os.path.join(
            output_dir,
            f"weekly_revenue_{date_str}.html"
        )
    )

    return fig


def create_kpi_summary(kpis, output_dir="output"):
    """Create and save a simple KPI summary table."""
    os.makedirs(output_dir, exist_ok=True)

    date_str = datetime.now().strftime("%Y%m%d")

    kpi_df = pd.DataFrame({
        "KPI": [
            "Total revenue",
            "Unique customers",
            "Average order value"
        ],
        "Value": [
            kpis["total_revenue"],
            kpis["unique_customers"],
            kpis["avg_order_value"]
        ]
    })

    fig = go.Figure(
        data=[
            go.Table(
                header=dict(values=list(kpi_df.columns)),
                cells=dict(values=[
                    kpi_df["KPI"],
                    kpi_df["Value"]
                ])
            )
        ]
    )

    fig.update_layout(title="KPI kokkuvõte")

    fig.write_html(
        os.path.join(
            output_dir,
            f"kpi_summary_{date_str}.html"
        )
    )

    return fig


def export_results(df, output_dir="output"):
    """Save a DataFrame to a timestamped CSV file."""
    os.makedirs(output_dir, exist_ok=True)

    date_str = datetime.now().strftime("%Y%m%d")
    output_path = os.path.join(
        output_dir,
        f"results_{date_str}.csv"
    )

    df.to_csv(output_path, index=False)

    return output_path
