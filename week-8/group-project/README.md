# Week 8 Group Project Snapshot

This folder preserves the final Week 8 collaborative project as part of the personal portfolio.

## Team roles

- Role A - Kalju: API data extraction
- Role B - Natalia: data transformation and cleaning
- Role C - Olga: visualization and export
- Role D - Helen: pipeline integration and end-to-end validation

## Source

Original repository: https://github.com/Kolju3/DACA-group
Source commit: 65519d0008b1c229555384531350b6aff10be648

The original group README is preserved as GROUP_README.md.

## Main files

- data_fetcher.py - Supabase API data extraction
- transform.py - merge, cleaning, aggregation and KPI calculation
- visualize_export.py - visualization and export
- pipeline.py - end-to-end pipeline orchestration

## Validation

The complete pipeline was validated with:

python pipeline.py --date 2025-03-01

![Pipeline execution validation](output/pipeline_execution_validation.png)

This snapshot preserves the final collaborative project independently of the original group repository.
