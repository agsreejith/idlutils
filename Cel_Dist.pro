function Cel_Dist, RA1, Dec1, RA2, Dec2
;+
; NAME:
;   Cel_Dist
;
; PURPOSE:
;   finds angular distance in radians between two points in the sky
;
; CATEGORY:
;   astro
;
; CALLING SEQUENCE:
;   distance = Cel_Dist (RA1, Dec1, RA2, Dec2)
;
; INPUTS:
;   RA1:  Right ascension of first point in radians
;   Dec1: Declination of first point in radians
;   RA2:  Right ascension of second point in radians
;   Dec2: Declination of second point in radians
;
; OPTIONAL INPUT PARAMETERS:
;   None.
;
; OUTPUTS:
;   Angular distance between point one and two in radians, type real.
;   The following procedure is used: The angle is the arccos ((A*B)/(|A||B|))
;   where A and B are the vectors in x,y,z of the viewing directions,
;   A*B the scalar product of these vectors, and |A| and |B| the length
;   of the vectors.
;
; COMMON BLOCKS:
;   None.
;
; SIDE EFFECTS:
;   Hopefully none.
;
; RESTRICTIONS:
;   Never know what the arcos does...
;
; MODIFICATION HISTORY:
;   1998 Jun 30, first version.
;   (c) Detlef Koschny
;-

  result = 0.0  ;define real number
  vec1 = fltarr (3)  ;define vectors with three elements
  vec2 = fltarr (3)

  vec1 = Cel2XYZ (RA1, Dec1)
  vec2 = Cel2XYZ (RA2, Dec2)
  result = acos (  (scal_prod (vec1, vec2)) $
                 / (vec_length (vec1) * vec_length (vec2)))
  return, result
end ;function Cel_Dist