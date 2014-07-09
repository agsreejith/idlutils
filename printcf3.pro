pro printcf3, cf3
;PURPOSE: To print the relevant information from the velocity
;structure to send off to collaborators. It prints the 
;julian date (jd), mean radial velocity (mnvel), 
;uncertainty in the radial velocity measurement (errvel), 
;and the detector used (dewar)
;
;INPUT: The velocity structure
;
; 2010.12.08 ~MJG

x1 = transpose(cf3.jd)
x2 = transpose(cf3.mnvel)
x3 = transpose(cf3.errvel)
x4 = transpose( (cf3.dewar eq 103) + 1) 
print, '  JD-2.44d6       RV     err detector'
print, [x1, x2, x3, x4], format='(F12.5, F8.2, F8.2, I3)'
print, '# Obs: ', n_elements(cf3.jd)
print, 'RMS: ', sqrt(total((cf3.mnvel - mean(cf3.mnvel))^2))
end;printcf3.pro