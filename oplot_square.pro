;+
;
;  NAME: 
;     oplot_square
;
;  PURPOSE: 
;   To draw a square when given the 4 vertices
;
;  CATEGORY:
;      UTILITIES
;
;  CALLING SEQUENCE:
;
;      oplot_square, [x1, x2, y1, y2], linestyle = 0, color=210, thick=5
;
;  INPUTS:
;     VERTS[0]: Bottom-Left vertex
;
;     VERTS[1]: Bottom-Right vertex
;
;     VERTS[2]: Top-Right vertex
;
;     VERTS[3]: Top-Left vertex
;
;  OPTIONAL INPUTS:
;
;  OUTPUTS:
;
;  OPTIONAL OUTPUTS:
;
;  KEYWORD PARAMETERS:
;    
;  EXAMPLE:
;      oplot_square, verts, linestyle = 0, color=210, thick=5
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2012.02.07 05:25:10 PM
;
;-
pro oplot_square, $
help = help, $
color = color, $
thick = thick, $ 
verts, $
linestyle = linestyle

x1 = verts[0]
x2 = verts[1]
y1 = verts[2]
y2 = verts[3]

if keyword_set(help) then begin
	print, '*************************************************'
	print, '*************************************************'
	print, '        HELP INFORMATION FOR square'
	print, 'KEYWORDS: '
	print, ''
	print, 'HELP: Use this keyword to print all available arguments'
	print, ''
	print, ''
	print, ''
	print, '*************************************************'
	print, '                     EXAMPLE                     '
	print, "IDL>"
	print, 'IDL> '
	print, '*************************************************'
	stop
endif

oplot, [x1, x2], [y1, y1], linestyle = linestyle, color = color, thick = thick
oplot, [x2, x2], [y1, y2], linestyle = linestyle, color = color, thick = thick
oplot, [x2, x1], [y2, y2], linestyle = linestyle, color = color, thick = thick
oplot, [x1, x1], [y2, y1], linestyle = linestyle, color = color, thick = thick



end;oplot_square.pro