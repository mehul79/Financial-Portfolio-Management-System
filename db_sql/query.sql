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
/

-- d) Verify that Assets.current_price was updated
SELECT asset_id, name, current_price
  FROM Assets
 WHERE asset_id = 1;


-- proc_compute_metrics_and_risk







