-- TRG_TRX_AFTER_INSERT
INSERT INTO Transactions (portfolio_id, asset_id, type, quantity, price)
VALUES (1, 1, 'BUY', 10, 175.00);

SELECT * FROM Audit_Log WHERE table_name = 'Transactions' ORDER BY log_id DESC;


-- TRG_MD_AFTER_UPDATE
UPDATE Market_Data
SET close_price = 179.75
WHERE asset_id = 1 AND data_date = (SELECT MAX(data_date) FROM Market_Data WHERE asset_id = 1);

SELECT name, current_price FROM Assets WHERE asset_id = 1;


-- TRG_WD_BEFORE_INSERT
INSERT INTO Withdrawals (user_id, amount, currency, status)
VALUES (1, 999999.00, 'USD', 'PENDING');

SELECT * FROM Withdrawals WHERE user_id = 1 ORDER BY withdrawal_id DESC;

-- TRG_DIV_AFTER_INSERT
INSERT INTO Dividends (portfolio_id, asset_id, dividend_amount)
VALUES (1, 1, 200.00);

SELECT * FROM Audit_Log
WHERE table_name = 'Dividends'
ORDER BY log_id DESC;

------------------------------------------------------------------------------

-- Procedure

-- proc_update_market_prices
-- a) View current prices
SELECT asset_id, name, current_price
  FROM Assets;

-- b) Insert today’s market data for an asset (if not already)
INSERT INTO Market_Data(asset_id, data_date, open_price, close_price, volume)
VALUES (1, SYSDATE, 180, 182.50, 100000);
COMMIT;

-- c) Run the procedure
BEGIN
  proc_update_market_prices;
END;

-- d) Verify that Assets.current_price was updated
SELECT asset_id, name, current_price
  FROM Assets
 WHERE asset_id = 1;

-------------------------------------------------------------

-- DBG_COMPUTE_METRICS
-- Portfolio's updated total value
SELECT total_value FROM Portfolios WHERE portfolio_id = 1;

-- Updated performance metrics
SELECT ROI, annual_return, profit_loss, metrics_date
FROM Performance_Metrics
WHERE portfolio_id = 1 AND TRUNC(metrics_date )= TRUNC(SYSDATE);

-- Updated risk analysis
SELECT volatility, sharpe_ratio, beta_coefficient, analysis_date
FROM Risk_Analysis
WHERE portfolio_id = 1 AND TRUNC(ANALYSIS_DATE ) = TRUNC(SYSDATE);

UPDATE Assets
SET current_price = 457.00  -- change this on new insertion
WHERE name = 'Apple Inc.';

BEGIN
  DBG_COMPUTE_METRICS(1);  -- Replace with your target portfolio_id
END;

SELECT total_value FROM Portfolios WHERE portfolio_id = 1;

SELECT ROI, annual_return, profit_loss, metrics_date
FROM Performance_Metrics
WHERE portfolio_id = 1 AND TRUNC(metrics_date )= TRUNC(SYSDATE);

SELECT volatility, sharpe_ratio, beta_coefficient, analysis_date
FROM Risk_Analysis
WHERE portfolio_id = 1 AND TRUNC(ANALYSIS_DATE ) = TRUNC(SYSDATE);

-------------------------------------------------------------------------

-- proc_auto_alerts

-- Simulate a big loss for portfolio 1
UPDATE Performance_Metrics
SET ROI = -0.50, annual_return = -0.45, profit_loss = -9000
WHERE portfolio_id = 1;

-- Simulate risky metrics for portfolio 1
UPDATE Risk_Analysis
SET sharpe_ratio = -0.5, volatility = 0.40
WHERE portfolio_id = 1;

COMMIT;

BEGIN
  proc_auto_alerts;
END;

SELECT * FROM Alerts
WHERE user_id = (
  SELECT user_id FROM Portfolios WHERE portfolio_id = 1
)
ORDER BY alert_id DESC;

-------------------------------------------------------------------------


-- f_calculate_roi
SELECT 
  p.portfolio_id,
  d.amount          AS start_value,
  p.total_value     AS end_value,
  f_calculate_roi(d.amount, p.total_value) AS calc_roi
FROM Portfolios p
JOIN (
  -- pick the earliest deposit per user
  SELECT user_id, MIN(deposit_date) AS dt
  FROM Deposits
  GROUP BY user_id
) first_dep ON first_dep.user_id = p.user_id
JOIN Deposits d 
  ON d.user_id = first_dep.user_id 
 AND d.deposit_date = first_dep.dt;



-- f_annualize_return
SELECT f_annualize_return(0.05, 180) AS annualized_return FROM dual;

SELECT
  portfolio_id,
  ROI               AS daily_roi,
  f_annualize_return(ROI, 1) AS annualized_return
FROM Performance_Metrics
WHERE TRUNC(metrics_date) = TRUNC(SYSDATE);


-- f_sharpe_ratio
SELECT
  ra.portfolio_id,
  pm.ROI            AS daily_roi,
  ra.volatility,
  f_sharpe_ratio(pm.ROI, ra.volatility, 0.02) AS calc_sharpe
FROM Performance_Metrics pm
JOIN Risk_Analysis   ra 
  ON ra.portfolio_id = pm.portfolio_id
 AND TRUNC(ra.analysis_date) = TRUNC(pm.metrics_date);

