CREATE OR REPLACE FUNCTION f_calculate_roi (
  p_start_value IN NUMBER,
  p_end_value   IN NUMBER
) RETURN NUMBER IS
  v_roi NUMBER;
BEGIN
  IF p_start_value > 0 THEN
    v_roi := (p_end_value - p_start_value) / p_start_value;
  ELSE
    v_roi := NULL;
  END IF;
  RETURN v_roi;
END f_calculate_roi;
/
