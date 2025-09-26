-- Rental benchmarks schema
CREATE TABLE IF NOT EXISTS `uk_prop.curated_dev.rental_benchmarks` (
  period DATE,
  la_code STRING,
  property_type STRING,
  median_rent NUMERIC
);
