CREATE OR REPLACE TRIGGER trg_wd_before_insert
BEFORE INSERT
  ON Withdrawals
FOR EACH ROW
DECLARE
  v_balance  NUMBER;
BEGIN
  -- 3a. Check account balance
  SELECT balance
    INTO v_balance
    FROM Accounts
   WHERE user_id = :NEW.user_id
   FOR UPDATE;
  
  IF v_balance < :NEW.amount THEN
    RAISE_APPLICATION_ERROR(-20001, 'Insufficient funds for withdrawal.');
  END IF;
  
  -- 3b. Deduct amount
  UPDATE Accounts
     SET balance = v_balance - :NEW.amount
   WHERE user_id = :NEW.user_id;
  
  -- 3c. Audit log entry
  INSERT INTO Audit_Log(action, table_name, user_id, description)
  VALUES (
    'INSERT',
    'Withdrawals',
    :NEW.user_id,
    'Withdrawal of ' || :NEW.amount || ' ' || :NEW.currency
  );
END trg_wd_before_insert;
/

