FUNCTION planckc, $
Js=Js, $
eVs=eVs, $
ergs=ergs, $
barJs=barJs, $
bareVs=bareVs, $
barergs=barergs
;PURPOSE: TO RETURN THE VALUE OF PLANCK'S CONSTANT IN THE APPROPRIATE UNITS
if keyword_set(Js) then planck=6.62606896d-34
if keyword_set(eVs) then planck=4.13566733d-15
if keyword_set(ergs) then planck=6.62606896d-27

if keyword_set(barJs) then planck=1.054571628d-34
if keyword_set(bareVs) then planck=6.58211899d-16
if keyword_set(barergs) then planck=1.054571628d-27


return, planck
end;planck.pro