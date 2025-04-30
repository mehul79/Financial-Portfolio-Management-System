CREATE OR REPLACE PROCEDURE proc_auto_alerts AS
BEGIN
  FOR rec IN (
    SELECT pm.portfolio_id, pm.ROI, p.user_id
      FROM Performance_Metrics pm
      JOIN Portfolios p ON pm.portfolio_id = p.portfolio_id
     WHERE TRUNC(pm.metrics_date) = TRUNC(SYSDATE)
       AND pm.ROI < 0
  ) LOOP
    INSERT INTO Alerts(alert_id, user_id, message, alert_type, created_at)
    VALUES (
      Alerts_SEQ.NEXTVAL,
      rec.user_id,
      'Portfolio '||rec.portfolio_id||' negative ROI: '||TO_CHAR(rec.ROI*100,'FM990.00')||'%',
      'Negative ROI',
      SYSDATE
    );
  END LOOP;
  COMMIT;
END proc_auto_alerts;
/
