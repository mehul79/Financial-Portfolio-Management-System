CREATE OR REPLACE TRIGGER trg_div_after_insert
AFTER INSERT
  ON Dividends
FOR EACH ROW
BEGIN
  -- 4a. Insert matching dividend transaction
  INSERT INTO Transactions (portfolio_id, asset_id, type, quantity, price)
  VALUES (
    :NEW.portfolio_id,
    :NEW.asset_id,
    'DIVIDEND',
    0,                -- dividends don’t change share count
    :NEW.dividend_amount
  );
  
  -- 4b. Audit log entry
  INSERT INTO Audit_Log(action, table_name, user_id, description)
  VALUES (
    'INSERT',
    'Dividends',
    NULL,
    'Dividend ' || :NEW.dividend_id ||
    ' of amount ' || :NEW.dividend_amount
  );
END trg_div_after_insert;
/

