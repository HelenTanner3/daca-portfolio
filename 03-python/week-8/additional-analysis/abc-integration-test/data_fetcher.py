import os
import logging
from pathlib import Path

import pandas as pd
from dotenv import load_dotenv
from supabase import create_client


# Logimise seadistus
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger(__name__)


# Loeb .env failist SUPABASE_URL ja SUPABASE_KEY
load_dotenv()

# Loob ühenduse Supabase'iga
supabase = create_client(
    os.getenv("SUPABASE_URL"),
    os.getenv("SUPABASE_KEY")
)


def get_data(table_name, start_date=None, end_date=None):
    """Load one Supabase table in 1000-row pages and return a DataFrame."""

    try:
        data = []          # siia kogutakse kõik saadud read
        page_size = 1000   # ühe API päringu suurus
        page = 0           # alustame esimesest leheküljest

        while True:
            # Valib tabeli ja küsib kõik veerud
            query = supabase.table(table_name).select("*")

            # Kuupäevafiltrid rakenduvad ainult sales tabelile
                ## gte = greater than or equal, ehk >=.
                ## lte = less than or equal, ehk <=.

            if start_date and table_name == "sales":
                query = query.gte("sale_date", start_date)

            if end_date and table_name == "sales":
                query = query.lte("sale_date", end_date)

            # Toob ühe 1000-realise lehe
            response = query.range(
                page * page_size,
                (page + 1) * page_size - 1
            ).execute()

            # Lisab saadud read varasematele juurde
            data.extend(response.data)

            # Kui tuli vähem kui 1000 rida, oleme tabeli lõpus
            if len(response.data) < page_size:
                break

            # Liigume järgmisele lehele
            page += 1

        # Muudab API-st saadud listi pandas DataFrame'iks
        df = pd.DataFrame(data)

        logger.info("%s: %s rows loaded", table_name, len(df))

        # Tühi tulemus loetakse veaks
        if df.empty:
            raise ValueError(f"{table_name} returned no rows")

        return df

    except Exception as e:
        logger.error("Error fetching data from %s: %s", table_name, e)

        fallback_path = Path("datasets") / f"{table_name}.csv"

        if fallback_path.exists():
            logger.info("Using CSV fallback: %s", fallback_path)
            return pd.read_csv(fallback_path)

        raise


def fetch_sales(start_date=None, end_date=None):
    """Fetch sales data with optional start and end date filters."""
    return get_data("sales", start_date=start_date, end_date=end_date)


def fetch_customers():
    """Fetch customer data."""
    return get_data("customers")


def fetch_products():
    """Fetch product data."""
    return get_data("products")