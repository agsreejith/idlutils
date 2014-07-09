function closest, vector, number
;PURPOSE: To return the value in VECTOR that is closest to NUMBER

bin = Value_Locate(vector, number )
;   Print, bin
;      37
;   Print, vector[bin], vector[bin+1]
;      31.0614      37.6096
;To find the closest value, we simple check the two vector values that bracket our chosen number. Make sure you check to see if your number actually lies within the values of the vector.

CASE 1 OF
   bin EQ -1: closest = 0
   bin EQ (N_Elements(vector)-1): closest = N_Elements(vector)-1
   ELSE: IF Abs(vector[bin] - number) GT Abs(vector[bin+1] - number) THEN $
            closest = bin+1 ELSE closest = bin
ENDCASE


return, closest
end;closest.pro