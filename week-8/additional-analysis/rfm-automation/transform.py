#Roll B - Data proccesing

import pandas as pd
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def clean_data(df: pd.DataFrame) -> pd.DataFrame:
    """
    Puhastab müügi- ja kliendiandmed:
    - Eemaldab duplikaadid
    - Muudab sale_date kuupäevavormingusse (datetime)
    - Eemaldab read, kus puuduvad kriitilised väljad (customer_id, sale_date, total_price)
    - Eemaldab null- ja negatiivse müügisummaga read (total_price > 0)
    """
    try:
        df_clean = df.drop_duplicates().copy()
        
        # 1. Teisendame müügikuupäeva datetime formaati
        if 'sale_date' in df_clean.columns:
            df_clean['sale_date'] = pd.to_datetime(df_clean['sale_date'], errors='coerce')
        
        # 2. Eemaldame read, kus puuduvad analüüsiks vajalikud andmed
        required_cols = [col for col in ['customer_id', 'sale_date', 'total_price'] if col in df_clean.columns]
        df_clean = df_clean.dropna(subset=required_cols)
        
        # 3. Välistame null- ja negatiivsed müügisummad (total_price > 0)
        if 'total_price' in df_clean.columns:
            df_clean = df_clean[df_clean['total_price'] > 0]

        logging.info(f"Cleaned data successfully: {len(df_clean)} rows remaining.")
        return df_clean
    except Exception as e:
        logging.error(f"Error in clean_data: {e}")
        raise

def merge_datasets(df_sales: pd.DataFrame, df_customers: pd.DataFrame) -> pd.DataFrame:
    """
    Liidab müügi- ja kliendiandmed customer_id veergu pidi.
    """
    try:
        if 'customer_id' in df_sales.columns and 'customer_id' in df_customers.columns:
            merged = pd.merge(df_sales, df_customers, on='customer_id', how='left')
            logging.info(f"Merged sales and customers: {len(merged)} rows.")
            return merged
        else:
            logging.warning("customer_id is missing in sales or customers dataframe.")
            return df_sales
    except Exception as e:
        logging.error(f"Error in merge_datasets: {e}")
        raise

def calculate_weekly_aggregates(df: pd.DataFrame) -> pd.DataFrame:
    """
    Grupeerib puhastatud andmed nädalate kaupa (sale_date alusel) 
    ja arvutab nädalase tulu, tellimuste arvu (sale_id alusel) ja keskmise ostusumma.
    """
    try:
        df_clean = df.copy()
        
        # Luuakse nädala alguse kuupäevaga veerg 'week'
        df_clean['week'] = df_clean['sale_date'].dt.to_period('W').dt.start_time
        
        # Kasutame tellimuste loendamiseks 'sale_id' (kui olemas) või varuvariandina 'id'
        order_col = 'sale_id' if 'sale_id' in df_clean.columns else ('id' if 'id' in df_clean.columns else 'total_price')
        
        weekly = df_clean.groupby('week').agg(
            revenue=('total_price', 'sum'),
            orders=(order_col, 'count'),
            avg_order_value=('total_price', 'mean')
        ).reset_index()

        logging.info("Calculated weekly aggregates.")
        return weekly
    except Exception as e:
        logging.error(f"Error in calculate_weekly_aggregates: {e}")
        raise

def calculate_kpis(df: pd.DataFrame) -> dict:
    """
    Arvutab kogunäitajad (KPI-d) stakeholder Marko jaoks:
    - Kogu käive (total_revenue)
    - Unikaalsed kliendid (unique_customers)
    - Keskmine ostusumma (avg_order_value)
    """
    try:
        total_revenue = float(df['total_price'].sum()) if 'total_price' in df.columns else 0.0
        unique_cust = int(df['customer_id'].nunique()) if 'customer_id' in df.columns else 0
        avg_order = float(df['total_price'].mean()) if 'total_price' in df.columns else 0.0

        kpis = {
            "total_revenue": round(total_revenue, 2),
            "unique_customers": unique_cust,
            "avg_order_value": round(avg_order, 2)
        }
        logging.info(f"Calculated KPIs: {kpis}")
        return kpis
    except Exception as e:
        logging.error(f"Error in calculate_kpis: {e}")
        raise
def segment_customer(row):
    if row["RFM_Score"] >= 13:
        return "VIP Champions"
    elif row["RFM_Score"] >= 10:
        return "Loyal"
    elif row["RFM_Score"] >= 7:
        return "Potential"
    elif row["RFM_Score"] >= 4:
        return "At Risk"
    else:
        return "Lost"


def calculate_rfm(df, reference_date=None):
    """Calculate RFM scores and customer segments."""
    if reference_date is None:
        reference_date = pd.to_datetime("today")
    else:
        reference_date = pd.to_datetime(reference_date)

    recency = (
        df.groupby("customer_id")["sale_date"]
        .max()
        .reset_index()
    )
    recency.columns = ["customer_id", "last_purchase_date"]

    recency["recency_days"] = (
        reference_date - recency["last_purchase_date"]
    ).dt.days

    frequency = (
        df.groupby("customer_id")["sale_id"]
        .count()
        .reset_index(name="frequency")
    )

    monetary = (
        df.groupby("customer_id")["total_price"]
        .sum()
        .reset_index(name="monetary_value")
    )

    rfm = (
        recency[["customer_id", "recency_days"]]
        .merge(frequency, on="customer_id")
        .merge(monetary, on="customer_id")
    )

    rfm["R_score"] = pd.qcut(
        rfm["recency_days"],
        5,
        labels=[5, 4, 3, 2, 1]
    )

    rfm["F_score"] = pd.qcut(
        rfm["frequency"].rank(method="first"),
        5,
        labels=[1, 2, 3, 4, 5]
    )

    rfm["M_score"] = pd.qcut(
        rfm["monetary_value"],
        5,
        labels=[1, 2, 3, 4, 5]
    )

    rfm["R_score"] = rfm["R_score"].astype(int)
    rfm["F_score"] = rfm["F_score"].astype(int)
    rfm["M_score"] = rfm["M_score"].astype(int)

    rfm["RFM_Score"] = (
        rfm["R_score"]
        + rfm["F_score"]
        + rfm["M_score"]
    )

    rfm["Segment"] = rfm.apply(
        segment_customer,
        axis=1
    )

    return rfm