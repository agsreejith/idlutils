function scal_prod, vector1, vector2
;+
; NAME:
;	scal_prod
;
; PURPOSE:
;       take the scalar product of the 3-dim. vectors, used for finding
;       the angle between two vectors
;
; CATEGORY:
;	Vector analysis
;
; CALLING SEQUENCE:
;	scalar_product = scal_prod (vector1, vector2)
;
; INPUTS:
;       vector1:  A column vector with any number of elements.
;       vector2:  Another column vector with the same number of elements.
;
; OPTIONAL INPUT PARAMETERS:
;	None.
;
; OUTPUTS:
;       The scalar product of the two vectors, defined as the sum of the
;       individual elements. Type is real.
;
; COMMON BLOCKS:
;	None.
;
; SIDE EFFECTS:
;	Hopefully none.
;
; RESTRICTIONS:
;       Returns an error if input vectors do not have equal no. of elements.
;
; MODIFICATION HISTORY:
;       1998 Jun 25, first version.
;       (c) Detlef Koschny
;-
  result = 0.0          ; dummy value
  info1 = size (vector1)
  info2 = size (vector2)

  if info1 (0) NE 1 then $
     print, '% SCAL_PROD: vector 1 not a one-dimensional vector!!!' $
  else if info2 (0) NE 1 then $
     print, '% SCAL_PROD: vector 2 not a one-dimensional vector!!!' $
  else if info2 (1) NE info1 (1) then $
     print, '% SCAL_PROD: vector 1 and 2 do not have same no. of elements!!!' $
  else begin
     for i = 0, info1 (1)-1 do result = result + vector1 (i) * vector2 (i)
  endelse
return, result
end ;function scal_prod