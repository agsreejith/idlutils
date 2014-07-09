pro ploterrbrs, X, Y, errArr, color = color, thick=thick

FOR j=0,n_elements(y)-1 do begin
 oplot, [X[j], X[j]], [Y[j]+errArr[j], Y[j]-errArr[j]], color = color, $
        thick=thick
ENDFOR ;j=0->#y
end; ploterrbrs.pro