CREATE OR REPLACE PROCEDURE proc_compute_metrics_and_risk AS
  CURSOR c_portfolios IS
    SELECT portfolio_id, total_value FROM Portfolios;
  v_old_value    NUMBER;
  v_new_value    NUMBER;
  v_roi          NUMBER;
  v_ann_return   NUMBER;
  v_profit_loss  NUMBER;
  v_volatility   NUMBER := 0.10;  -- placeholder
  v_sharpe       NUMBER;
  v_beta         NUMBER := 1.0;   -- placeholder
BEGIN
  FOR r IN c_portfolios LOOP
    -- current portfolio value
    SELECT NVL(SUM(pa.quantity * a.current_price),0)
      INTO v_new_value
      FROM Portfolio_Assets pa
      JOIN Assets a ON pa.asset_id = a.asset_id
     WHERE pa.portfolio_id = r.portfolio_id;
    v_old_value := r.total_value;
    
    v_roi        := CASE WHEN v_old_value > 0 
                         THEN (v_new_value - v_old_value) / v_old_value 
                         ELSE NULL END;
    v_ann_return := v_roi * 365;
    v_profit_loss:= v_new_value - v_old_value;
    v_sharpe     := CASE WHEN v_volatility > 0 THEN v_roi / v_volatility ELSE NULL END;
    
    -- upsert Performance_Metrics
    MERGE INTO Performance_Metrics pm
    USING (SELECT r.portfolio_id AS pid, TRUNC(SYSDATE) AS d FROM DUAL) src
      ON (pm.portfolio_id = src.pid AND TRUNC(pm.metrics_date)=src.d)
    WHEN MATCHED THEN
      UPDATE SET
        pm.ROI           = v_roi,
        pm.annual_return = v_ann_return,
        pm.profit_loss   = v_profit_loss
    WHEN NOT MATCHED THEN
      INSERT (performance_id, portfolio_id, ROI, annual_return, profit_loss, metrics_date)
      VALUES (Performance_Metrics_SEQ.NEXTVAL,
              r.portfolio_id, v_roi, v_ann_return, v_profit_loss, TRUNC(SYSDATE));
    
    -- upsert Risk_Analysis
    MERGE INTO Risk_Analysis ra
    USING (SELECT r.portfolio_id AS pid, TRUNC(SYSDATE) AS d FROM DUAL) src
      ON (ra.portfolio_id = src.pid AND TRUNC(ra.analysis_date)=src.d)
    WHEN MATCHED THEN
      UPDATE SET
        ra.volatility       = v_volatility,
        ra.sharpe_ratio     = v_sharpe,
        ra.beta_coefficient = v_beta
    WHEN NOT MATCHED THEN
      INSERT (risk_id, portfolio_id, volatility, sharpe_ratio, beta_coefficient, analysis_date)
      VALUES (Risk_Analysis_SEQ.NEXTVAL,
              r.portfolio_id, v_volatility, v_sharpe, v_beta, TRUNC(SYSDATE));
  END LOOP;

  -- finally sync Portfolios.total_value
  UPDATE Portfolios p
     SET p.total_value = (
       SELECT NVL(SUM(pa.quantity * a.current_price),0)
         FROM Portfolio_Assets pa
         JOIN Assets a ON pa.asset_id = a.asset_id
        WHERE pa.portfolio_id = p.portfolio_id
     );
  COMMIT;
END proc_compute_metrics_and_risk;
/
