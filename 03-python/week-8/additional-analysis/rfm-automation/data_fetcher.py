import os
import pandas as pd
from supabase import create_client
from dotenv import load_dotenv

load_dotenv()
SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_KEY")

if not SUPABASE_URL or not SUPABASE_KEY:
    raise ValueError("Missing SUPABASE_URL or SUPABASE_KEY in .env file")

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)


def fetch_sales(start_date=None, end_date=None):
    try:
        all_data = []
        offset = 0
        limit = 1000

        while True:
            # MUUDETUD: query luuakse iga pagination'i lehe jaoks uuesti
            query = supabase.table("sales").select("*").order("id")    # lisatud order by id, et tagada järjepidev andmete järjekord

            if start_date:
                # MUUDETUD: date -> sale_date
                query = query.gte("sale_date", start_date)

            if end_date:
                # MUUDETUD: date -> sale_date ja lte -> lt
                query = query.lt("sale_date", end_date)

            response = query.limit(limit).offset(offset).execute()
            data = response.data
            if not data:
                break
            all_data.extend(data)
            if len(data) < limit:
                break
            offset += limit

        return pd.DataFrame(all_data)

    except Exception as e:
        print(f"Error fetching sales from Supabase: {e}")
        print("Falling back to local CSV file 'Data/sales.csv'")
        csv_path = os.path.join("Data", "sales.csv")
        return pd.read_csv(csv_path)


def fetch_customers():
    try:
        query = supabase.table("customers").select("*")
        all_data = []
        offset = 0
        limit = 1000
        while True:
            response = query.limit(limit).offset(offset).execute()
            data = response.data
            if not data:
                break
            all_data.extend(data)
            if len(data) < limit:
                break
            offset += limit
        return pd.DataFrame(all_data)

    except Exception as e:
        print(f"Error fetching customers from Supabase: {e}")
        print("Falling back to local CSV file 'Data/customers.csv'")
        csv_path = os.path.join("Data", "customers.csv")
        return pd.read_csv(csv_path)


def fetch_products():
    try:
        query = supabase.table("products").select("*")
        all_data = []
        offset = 0
        limit = 1000
        while True:
            response = query.limit(limit).offset(offset).execute()
            data = response.data
            if not data:
                break
            all_data.extend(data)
            if len(data) < limit:
                break
            offset += limit
        return pd.DataFrame(all_data)

    except Exception as e:
        print(f"Error fetching products from Supabase: {e}")
        print("Falling back to local CSV file 'Data/products.csv'")
        csv_path = os.path.join("Data", "products.csv")
        return pd.read_csv(csv_path)