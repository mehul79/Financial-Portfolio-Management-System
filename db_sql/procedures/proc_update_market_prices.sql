CREATE OR REPLACE PROCEDURE proc_update_market_prices AS
BEGIN
  UPDATE Assets a
     SET a.current_price = (
       SELECT md.close_price
         FROM Market_Data md
        WHERE md.asset_id = a.asset_id
          AND TRUNC(md.data_date) = TRUNC(SYSDATE)
     )
   WHERE EXISTS (
       SELECT 1
         FROM Market_Data md
        WHERE md.asset_id = a.asset_id
          AND TRUNC(md.data_date) = TRUNC(SYSDATE)
     );
  COMMIT;
END proc_update_market_prices;
/
