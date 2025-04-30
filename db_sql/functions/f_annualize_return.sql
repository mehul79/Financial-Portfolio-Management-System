CREATE OR REPLACE FUNCTION f_annualize_return (
  p_roi  IN NUMBER,
  p_days IN NUMBER
) RETURN NUMBER IS
  v_ann_ret NUMBER;
BEGIN
  IF p_days > 0 AND p_roi IS NOT NULL THEN
    v_ann_ret := POWER(1 + p_roi, 365 / p_days) - 1;
  ELSE
    v_ann_ret := NULL;
  END IF;
  RETURN v_ann_ret;
END f_annualize_return;
/
