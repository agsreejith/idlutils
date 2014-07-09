function idint, num
;PURPOSE: The same as the Fortran function IDINT. 
; IDINT (number)
;
; A function that returns the largest integer whose absolute value
; does not exceed the absolute value of the argument and has the same
; sign as the argument.
;
; 20100810 ~M. Giguere

return, (num ge 0)*floor(num) - (num lt 0)*ceil(num)

end;idint.pro