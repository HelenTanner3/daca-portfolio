import logging

import pandas as pd

logger = logging.getLogger(__name__)


def merge_datasets(df_sales, df_customers):
    """Merge sales and customers on customer_id using a left join."""
    try:
        return pd.merge(
            df_sales,
            df_customers,
            how="left",
            on="customer_id"
        )
    except Exception as e:
        logger.error("Error merging datasets: %s", e)
        raise


def clean_data(df):
    """Remove duplicates, handle key NULLs, parse dates and remove non-positive sales."""
    try:
        df_clean = df.copy()

        df_clean = df_clean.drop_duplicates()

        if "sale_date" in df_clean.columns:
            df_clean["sale_date"] = pd.to_datetime(
                df_clean["sale_date"],
                errors="coerce"
            )

        required_columns = [
            column
            for column in ["customer_id", "sale_date", "total_price"]
            if column in df_clean.columns
        ]

        if required_columns:
            df_clean = df_clean.dropna(subset=required_columns)

        if "total_price" in df_clean.columns:
            df_clean = df_clean[df_clean["total_price"] > 0]

        return df_clean

    except Exception as e:
        logger.error("Error cleaning data: %s", e)
        raise


def calculate_weekly_aggregates(df):
    """Calculate weekly revenue, order count and average order value."""
    try:
        weekly = (
            df
            .set_index("sale_date")
            .resample("W")
            .agg(
                revenue=("total_price", "sum"),
                orders=("sale_id", "nunique")
            )
            .reset_index()
            .rename(columns={"sale_date": "week"})
        )

        weekly = weekly[weekly["orders"] > 0].copy()

        weekly["avg_order_value"] = (
            weekly["revenue"] / weekly["orders"]
        )

        return weekly

    except Exception as e:
        logger.error("Error calculating weekly aggregates: %s", e)
        raise


def calculate_kpis(df):
    """Return total revenue, unique customers and average order value."""
    try:
        total_revenue = df["total_price"].sum()
        order_count = df["sale_id"].nunique()

        avg_order_value = (
            total_revenue / order_count
            if order_count > 0
            else 0
        )

        return {
            "total_revenue": round(float(total_revenue), 2),
            "unique_customers": int(df["customer_id"].nunique()),
            "avg_order_value": round(float(avg_order_value), 2)
        }

    except Exception as e:
        logger.error("Error calculating KPIs: %s", e)
        raise
