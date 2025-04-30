CREATE OR REPLACE TRIGGER trg_md_after_update
AFTER UPDATE OF close_price
  ON Market_Data
FOR EACH ROW
BEGIN
  -- 2a. Update Assets.current_price
  UPDATE Assets
     SET current_price = :NEW.close_price
   WHERE asset_id = :NEW.asset_id;
  
  -- 2b. Audit log entry
  INSERT INTO Audit_Log(action, table_name, user_id, description)
  VALUES (
    'UPDATE',
    'Market_Data',
    NULL,
    'Market_Data ' || :NEW.market_data_id ||
    ' close_price changed from ' || :OLD.close_price ||
    ' to ' || :NEW.close_price
  );
END trg_md_after_update;
/

