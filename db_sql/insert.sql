-- 1. Insert Users
INSERT INTO Users (name, email, password, role)
VALUES 
  ('Alice Johnson', 'alice@example.com', 'alice_pass', 'investor'),
  ('Bob Smith', 'bob@example.com', 'bob_pass', 'manager');

-- 2. Insert Accounts
INSERT INTO Accounts (user_id, account_type, balance, currency)
VALUES 
  (1, 'Savings', 15000.00, 'USD'),
  (2, 'Brokerage', 30000.00, 'USD');

-- 3. Insert Assets
INSERT INTO Assets (name, type, ticker_symbol, current_price, market_cap)
VALUES 
  ('Apple Inc.', 'Stock', 'AAPL', 175.50, 2800000000000),
  ('Bitcoin', 'Crypto', 'BTC', 29000.00, 550000000000),
  ('Tesla Inc.', 'Stock', 'TSLA', 190.25, 700000000000);

-- 4. Insert Portfolios
INSERT INTO Portfolios (user_id, total_value, risk_level)
VALUES 
  (1, 18000.00, 'Medium'),
  (2, 32000.00, 'High');

-- 5. Insert Portfolio_Assets
INSERT INTO Portfolio_Assets (portfolio_id, asset_id, quantity, buy_price)
VALUES 
  (1, 1, 20, 170.00),  -- Alice owns AAPL
  (1, 2, 0.5, 25000.00),  -- Alice owns BTC
  (2, 3, 15, 185.00);  -- Bob owns TSLA

-- 6. Insert Transactions
INSERT INTO Transactions (portfolio_id, asset_id, type, quantity, price)
VALUES 
  (1, 1, 'BUY', 20, 170.00),
  (1, 2, 'BUY', 0.5, 25000.00),
  (2, 3, 'BUY', 15, 185.00);

-- 7. Insert Orders
INSERT INTO Orders (user_id, asset_id, order_type, quantity, order_status)
VALUES 
  (1, 1, 'BUY', 10, 'COMPLETED'),
  (2, 3, 'SELL', 5, 'PENDING');

-- 8. Insert Market_Data
INSERT INTO Market_Data (asset_id, data_date, open_price, close_price, volume)
VALUES 
  (1, SYSDATE, 172.00, 175.50, 1500000),
  (2, SYSDATE, 28000.00, 29000.00, 35000),
  (3, SYSDATE, 188.00, 190.25, 1200000);

-- 9. Insert Currency_Exchange
INSERT INTO Currency_Exchange (currency_from, currency_to, exchange_rate)
VALUES 
  ('USD', 'INR', 83.20),
  ('USD', 'EUR', 0.91);

-- 10. Insert Risk_Analysis
INSERT INTO Risk_Analysis (portfolio_id, volatility, sharpe_ratio, beta_coefficient)
VALUES 
  (1, 0.15, 1.20, 1.05),
  (2, 0.25, 0.95, 1.30);

-- 11. Insert Performance_Metrics
INSERT INTO Performance_Metrics (portfolio_id, ROI, annual_return, profit_loss)
VALUES 
  (1, 0.12, 0.10, 2000.00),
  (2, 0.18, 0.16, 4500.00);

-- 12. Insert Alerts
INSERT INTO Alerts (user_id, message, alert_type)
VALUES 
  (1, 'Your BTC dropped below $30K', 'Price Alert'),
  (2, 'Portfolio gained 10% in a week!', 'Performance Alert');

-- 13. Insert Deposits
INSERT INTO Deposits (user_id, amount, currency)
VALUES 
  (1, 10000.00, 'USD'),
  (2, 15000.00, 'USD');

-- 14. Insert Withdrawals
INSERT INTO Withdrawals (user_id, amount, currency, status)
VALUES 
  (1, 2000.00, 'USD', 'COMPLETED'),
  (2, 3000.00, 'USD', 'PENDING');

-- 15. Insert Dividends
INSERT INTO Dividends (portfolio_id, asset_id, dividend_amount)
VALUES 
  (1, 1, 120.00),
  (2, 3, 240.00);

-- 16. Insert Audit_Log
INSERT INTO Audit_Log (action, table_name, user_id, description)
VALUES 
  ('INSERT', 'Transactions', 1, 'User 1 bought 20 shares of AAPL'),
  ('UPDATE', 'Portfolios', 2, 'Updated total value after TSLA price rise');

