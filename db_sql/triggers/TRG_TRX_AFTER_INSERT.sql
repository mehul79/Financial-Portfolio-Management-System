CREATE OR REPLACE TRIGGER trg_trx_after_insert
AFTER INSERT
  ON Transactions
FOR EACH ROW
DECLARE
  v_new_qty   NUMBER;
  v_total_val NUMBER;
BEGIN
  -- 1a. Update or insert into Portfolio_Assets
  BEGIN
    SELECT quantity
      INTO v_new_qty
      FROM Portfolio_Assets
     WHERE portfolio_id = :NEW.portfolio_id
       AND asset_id     = :NEW.asset_id
    FOR UPDATE;
    
    -- Already exists → update quantity
    v_new_qty := v_new_qty 
               + CASE WHEN :NEW.type = 'BUY' THEN :NEW.quantity ELSE -:NEW.quantity END;
               
    UPDATE Portfolio_Assets
       SET quantity = v_new_qty
     WHERE portfolio_id = :NEW.portfolio_id
       AND asset_id     = :NEW.asset_id;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      -- New asset in portfolio → insert
      IF :NEW.type = 'BUY' THEN
        INSERT INTO Portfolio_Assets(portfolio_id, asset_id, quantity, buy_price)
        VALUES(:NEW.portfolio_id, :NEW.asset_id, :NEW.quantity, :NEW.price);
      END IF;
  END;
  
  -- 1b. Recalculate total_value of portfolio
  SELECT SUM(pa.quantity * a.current_price)
    INTO v_total_val
    FROM Portfolio_Assets pa
    JOIN Assets a
      ON pa.asset_id = a.asset_id
   WHERE pa.portfolio_id = :NEW.portfolio_id;
  
  UPDATE Portfolios
     SET total_value = NVL(v_total_val, 0)
   WHERE portfolio_id = :NEW.portfolio_id;
  
  -- 1c. Audit log entry
  INSERT INTO Audit_Log(action, table_name, user_id, description)
  VALUES (
    'INSERT',
    'Transactions',
    NULL,  -- we don’t have a user_id here; consider passing it via context if needed
    'Transaction ' || :NEW.transaction_id || 
    ' of type ' || :NEW.type ||
    ' on portfolio ' || :NEW.portfolio_id
  );
END trg_trx_after_insert;



