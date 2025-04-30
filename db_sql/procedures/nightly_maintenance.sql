CREATE OR REPLACE PROCEDURE nightly_maintenance AS
BEGIN
  proc_update_market_prices;
  proc_compute_metrics_and_risk;
  proc_auto_alerts;
END nightly_maintenance;
/
