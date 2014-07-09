;****************************************************
PRO Help_Var

; Just print out the variables!

names = ROUTINE_NAMES(Variables=1)

FOR j=0, N_Elements(names) - 1 DO BEGIN
   IF N_Elements(ROUTINE_NAMES(names[j], FETCH=1)) GT 0 THEN BEGIN
   value  = ROUTINE_NAMES(names[j], FETCH=1)
   HELP, value, Output=s
   UnDefine, value
   Print, StrUpCase(names[j]) + StrMid(s, 6)
ENDIF
ENDFOR

END
;****************************************************

