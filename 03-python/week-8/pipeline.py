# Pythoni standardteegid: logging jälgib programmi tööd, time mõõdab pipeline'i kestust
import logging
import time
import sys

# Roll A: funktsioonid müügi- ja kliendiandmete laadimiseks
from data_fetcher import fetch_sales, fetch_customers

# Roll B: funktsioonid andmete ühendamiseks, puhastamiseks ja koondnäitajate arvutamiseks
from transform import clean_data, calculate_weekly_aggregates, calculate_kpis, merge_datasets
# Roll C: funktsioonid tulemuste visualiseerimiseks ja eksportimiseks
from visualize_export import create_weekly_chart, create_kpi_summary, export_results
# Määrab, milliseid logiteateid näidatakse ja millisel kujul need terminalis kuvatakse
# See ei tee veel pipeline'is ühtegi tegevust. See määrab ainult reeglid, kuidas hilisemad logiteated kuvatakse.
logging.basicConfig(
# Määrab logimise taseme. Kuvatakse ainult teated, mis on vähemalt INFO tasemel (INFO, WARNING, ERROR, CRITICAL)
    level=logging.INFO,  
# Määrab logiteadete formaadi. See näitab logiteate kuupäeva ja kellaaja, taseme (INFO, ERROR jne) ja sõnumit.
    format='%(asctime)s - %(levelname)s - %(message)s')
# Loob selle faili jaoks loggeri, millega saame hiljem kirjutada logger.info(), logger.error() jne
logger = logging.getLogger(__name__)

# Käivitab kogu pipeline'i etapid õiges järjekorras
def run_pipeline(date=None):
    try:
        logger.info("Pipeline started")
 # EXTRACT: Roll A funktsioonid toovad müügi- ja kliendiandmed
        logger.info("Fetching data...")
        sales_df = fetch_sales(end_date=date)
        customers_df = fetch_customers()
        # Kontroll: mitu rida mõlemast tabelist saime
        logger.info(f"Sales rows: {len(sales_df)}, customer rows: {len(customers_df)}")

 # TRANSFORM: Roll B ühendab ja töötleb Roll A-st saadud andmed
        # Liidame müügi- ja kliendiandmed customer_id järgi
        df = merge_datasets(sales_df, customers_df)
        logger.info(f"Merged DataFrame shape: {df.shape}")
        # Puhastame ühendatud andmed
        df_clean = clean_data(df)
        logger.info(f"Clean DataFrame shape: {df_clean.shape}")
        # Kontroll: mitu rida puhastamise käigus eemaldati
        logger.info(f"Rows removed during cleaning: {len(df) - len(df_clean)}")
        # Arvutame puhastatud andmetest nädalased koondnäitajad
        df_weekly = calculate_weekly_aggregates(df_clean)
        logger.info(f"Weekly DataFrame shape: {df_weekly.shape}")
        # Arvutame puhastatud andmetest põhilised KPI-d
        kpis = calculate_kpis(df_clean)
        logger.info(f"KPIs: {kpis}")

 # VISUALIZE + EXPORT: Roll C loob visualiseeringud ja salvestab tulemused
        logger.info("Creating visualizations and exporting results...")

        weekly_chart = create_weekly_chart(df_weekly)
        kpi_chart = create_kpi_summary(kpis)

        csv_path = export_results(df_weekly, "output")

        weekly_chart.write_html("output/weekly_revenue.html")
        kpi_chart.write_html("output/kpi_summary.html")

        # Kontroll: export_results() tagastab loodud CSV-faili asukoha
        logger.info(f"CSV exported: {csv_path}")


 # Roll D Pipeline läbis kõik etapid edukalt
        logger.info(f"Pipeline complete: {len(df_clean)} cleaned rows processed")
        return True


    except Exception as e:
        logger.error(f"Pipeline failed: {e}")
        return False

# Käivitab pipeline'i otse ja mõõdab kogu töö kestust
if __name__ == "__main__":
    start_time = time.time()

    date = sys.argv[2] if len(sys.argv) > 2 and sys.argv[1] == "--date" else None

    run_pipeline(date)

    elapsed_time = time.time() - start_time
    logger.info(f"Total pipeline time: {elapsed_time:.2f} seconds")