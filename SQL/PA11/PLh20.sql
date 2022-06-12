-- File PLh20.sql 
-- Author: Ethan Grant
------------------------------------------------------------------- 
SET SERVEROUTPUT ON  
SET VERIFY OFF 
------------------------------------ 
ACCEPT  rateDecrement NUMBER PROMPT 'Enter the rate decrement: ' 
ACCEPT  allowedMinRate NUMBER PROMPT 'Enter the allowed min. rate: ' 
DECLARE 
   sr     boats%ROWTYPE;
   CURSOR bCursor IS
          SELECT B.bid, B.bname, B.color, B.rate, B.length, B.logKeeper
          FROM   boats B
          WHERE NOT EXISTS
		(SELECT B1.bid
		 FROM Boats B1, Reservations R 
		 WHERE R.bid = B1.bid AND B.bid = B1.bid)
          ORDER BY b.bid;
BEGIN 
   OPEN bCursor;
   LOOP
      -- Fetch the qualifying rows one by one
      FETCH bCursor INTO sr;
      EXIT WHEN bCursor%NOTFOUND;
      -- Print the boat's old record
      DBMS_OUTPUT.PUT_LINE ('+++++ old row: '||sr.bid||' '
             ||sr.bname||' '||sr.color||'  '||sr.rate||'  '||sr.length||' '||sr.logKeeper); 
      sr.rate := sr.rate - &rateDecrement;

      -- A nested block
      DECLARE 
         belowAllowedMin EXCEPTION;
      BEGIN  
         IF   sr.rate < &allowedMinRate 
         THEN RAISE belowAllowedMin;
         ELSE UPDATE boats
              SET rate = sr.rate
              WHERE boats.bid = sr.bid;
              -- Print the boat's new record
      DBMS_OUTPUT.PUT_LINE ('+++++ new row: '||sr.bid||' '
             ||sr.bname||' '||sr.color||'  '||sr.rate||'  '||sr.length||' '||sr.logKeeper);    
         END IF;

      EXCEPTION
        WHEN belowAllowedMin THEN
           DBMS_OUTPUT.PUT_LINE('+++++ Update rejected: '||
 			'The new rate would have been: '|| sr.rate);
        WHEN OTHERS THEN
           DBMS_OUTPUT.PUT_LINE('+++++ update rejected: ' ||
                                   SQLCODE||'...'||SQLERRM);
      END;
      -- end of the nested block
END LOOP;

   COMMIT;
   CLOSE bCursor;
END; 
/