CREATE OR REPLACE FUNCTION f_sharpe_ratio (
  p_return       IN NUMBER,            -- e.g. ROI or annualized return
  p_volatility   IN NUMBER,            -- standard deviation of returns
  p_risk_free_rt IN NUMBER DEFAULT 0.02 -- default 2% annual risk-free
) RETURN NUMBER IS
  v_sharpe NUMBER;
BEGIN
  IF p_volatility > 0 AND p_return IS NOT NULL THEN
    v_sharpe := (p_return - p_risk_free_rt) / p_volatility;
  ELSE
    v_sharpe := NULL;
  END IF;
  RETURN v_sharpe;
END f_sharpe_ratio;
/
