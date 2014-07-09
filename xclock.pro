;+
; NAME:
;       XCLOCK
;
; PURPOSE:
;
;       This widget program simulates a simple analog clock.
;
; AUTHOR:
;
;       Robert M. Dimeo, Ph.D.
;	NIST Center for Neutron Research
;       100 Bureau Drive
;	Gaithersburg, MD 20899
;       Phone: (301) 975-8135
;       E-mail: robert.dimeo@nist.gov
;       http://www.ncnr.nist.gov/staff/dimeo
;
; CATEGORY:
;
;       Widgets
;
; CALLING SEQUENCE:
;
;       XCLOCK
;
; INPUT FIELDS:
;
;	NONE
;
; KEYWORD PARAMETERS:
;
;	ANALOG:		This keyword, when set, causes the display to appear like a
;			clock face.
;
;	DIGITAL:	This keyword, when set, causes the display to show a text output
;			of the date and time.
;
; DISCLAIMER
;
;	This software is provided as is without any warranty whatsoever.
;	Permission to use, copy, modify, and distribute modified or
;	unmodified copies is granted, provided this disclaimer
;	is included unchanged.
;
; MODIFICATION HISTORY:
;
;       Written by Rob Dimeo, November 10, 2002.
;	-November 14, 2002: Added ANALOG and DIGITAL keyword parameters.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro xClockCleanup,tlb
compile_opt idl2,hidden
widget_control,tlb,/clear_events
widget_control,tlb,get_uvalue = pState
wdelete,(*pState).winPix
ptr_free,pState
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro xClockQuit,event
compile_opt idl2,hidden
; We simply destroy the top-level base here and then the cleanup routine is
; executed.
widget_control,event.top,/destroy
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro xClock_showDigital,event
compile_opt idl2,hidden
widget_control,event.top,get_uvalue = pState
xrange = [-1.0,1.0]
yrange = xrange
plot,xrange,yrange,/nodata,xrange = xrange,yrange = yrange, $
  xstyle = 4,ystyle = 4,background = (*pState).backColor,xmargin = [0,0], $
  ymargin = [0,0]
xyouts,0.5,0.5,systime(),color = (*pState).foreColor,/normal,alignment = 0.5, $
  charsize = 1.5
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro xClock_showFace,event
compile_opt idl2,hidden
widget_control,event.top,get_uvalue = pState
xrange = [-1.0,1.0]
yrange = xrange
plot,xrange,yrange,/nodata,xrange = xrange,yrange = yrange, $
  xstyle = 4,ystyle = 4,background = (*pState).backColor,xmargin = [0,0], $
  ymargin = [0,0]
; Plot the clock face
th = 90.0-(360./12)-(360.0/12.0)*findgen(12)
r = 0.75
xt = r*cos(th*!dtor)
yt = r*sin(th*!dtor)
xyouts,xt,yt,strtrim(string(1+indgen(12)),2),/data,alignment = 0.5, $
		color = (*pState).foreColor,charsize = 1.25
ncircle = 50

rc = 0.85
thc = (360./(ncircle - 1))*findgen(ncircle)
xc = rc*cos(thc*!dtor)
yc = rc*sin(thc*!dtor)
plots,xc,yc,/data, thick = 2.0,color = (*pState).foreColor
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro xClock_draw,event
compile_opt idl2,hidden
widget_control,event.top,get_uvalue = pState
caldat,systime(/julian),month,day,year,hour,minute,second

if hour gt 12 then hour = hour mod 12

; Calculate the second hand
ths = 90.0-(360.0/60.)*second
rs = 0.80
xs = rs*cos(ths*!dtor) & ys = rs*sin(ths*!dtor)
; Calculate the minute hand
thm = 90.0-(360.0/60.)*minute
rm = 0.65
xm = rm*cos(thm*!dtor) & ym = rm*sin(thm*!dtor)

; Calculate the hour hand
; Note that we will provide a contribution from the
; minutes value so that the hour hand changes every
; minute rather than abruptly once every hour.
rh = 0.5
thh = 90.0-(360.0/12.)*(hour+float(minute)/60.0)
xh = rh*cos(thh*!dtor) & yh = rh*sin(thh*!dtor)

; Draw the seconds hand
plots,[0.0,xs],[0.0,ys],/data,thick = 1,color = (*pState).foreColor
; Draw the minutes hand
plots,[0.0,xm],[0.0,ym],/data, thick = 2,color = (*pState).foreColor
; Draw the hour hand
plots,[0.0,xh],[0.0,yh],/data, thick = 4,color = (*pState).foreColor

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro xClock_resize,event
compile_opt idl2,hidden
widget_control,event.top,get_uvalue = pState
newsize = event.x > event.y	; pick the larger of the two dimensions
xsize = newsize & ysize = newsize
; Delete the existing pixmap and create a new one of the appropriate size.
wdelete,(*pState).winPix
window,/free,/pixmap,xsize = xsize,ysize = ysize
widget_control,(*pState).win,draw_xsize = xsize,draw_ysize = ysize
; Fire the timer immediately so that the resizing looks seamless.
widget_control,(*pState).timer,time = 0.0
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro xClock_event,event
compile_opt idl2,hidden
widget_control,event.top,get_uvalue = pState
if tag_names(event,/structure_name) eq 'WIDGET_BASE' then begin
  xClock_resize,event
  return
endif

wset,(*pState).winPix
if (*pState).type eq 0 then begin
  xClock_showFace,event
  xClock_draw,event
endif else begin
  xClock_showDigital,event
endelse
wset,(*pState).winVis
device,copy = [0,0,!d.x_size,!d.y_size,0,0,(*pState).winPix]
; Fire off the timer every once per second
widget_control,(*pState).timer,time = (*pState).duration
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro xClock,group_leader = group_leader,analog = analog,digital = digital
compile_opt idl2,hidden
; Turn color decomposition off so that we can use simple color indexing for
; plot and annotation commands.
device,decomposed = 0
; Load the black & white color table
loadct,0,/silent
type = 0
if keyword_set(analog) then type = 0
if keyword_set(digital) then type = 1

title = 'XCLOCK'
if n_elements(group_leader) ne 0 then begin
  tlb = widget_base(/col,group_leader = group_leader,title = title, $
        /tlb_size_events)
endif else begin
  tlb = widget_base(/col,title = title,/tlb_size_events)
endelse
if type eq 0 then begin
  xsize = 300 & ysize = xsize
endif else begin
  xsize = 300 & ysize = 100
endelse
win = widget_draw(tlb,xsize = xsize,ysize = ysize)
timer = widget_base(tlb)

widget_control,tlb,/realize
widget_control,win,get_value = winVis
window,/free,/pixmap,xsize = xsize,ysize = ysize
winPix = !d.window

; Define the state structure
state = {	win:win,		$
		winVis:winVis,		$
		winPix:winPix,		$
		duration:1.0,		$
		foreColor:0,		$
		backColor:255,		$
		type:type,		$
		timer:timer		$
		}
; Create a pointer to the state structure
pState = ptr_new(state,/no_copy)
; Stuff the (pointer to the) state structure into the user-value
; of the top-level base.
widget_control,tlb,set_uvalue = pState

; Fire off the timer immediately so that the clock face
; is displayed at once.  After this we fire off the timer
; only once every (*pState).duration (or 1 second).
widget_control,(*pState).timer,time = 0.0

; Start the event loop by calling XMANAGER
xmanager,'xClock',tlb,/no_block,cleanup = 'xClockCleanup'

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;