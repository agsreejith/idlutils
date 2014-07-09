function boltzc, $
JK=JK, $
eVK=eVK, $
ergK=ergK
;PURPOSE: To return Boltzmann's Constant
print, 'evK'
print, 'JK'
print, 'ergK'

if keyword_set(JK) then boltz=1.3806504d-23
if keyword_set(eVK) then boltz=8.617343d-5
if keyword_set(ergK) then boltz=1.3806504d-16

return, boltz
end;boltzc.pro