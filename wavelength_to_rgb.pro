;+
;
;  NAME: 
;     wavelength_to_rgb
;
;  PURPOSE: Convert approximate visible wavelength to RGB
;		based on this fortran code:
;		http://www.physics.sfasu.edu/astro/color/spectra.html
;   
;
;  CATEGORY:
;      CHIRON
;
;  CALLING SEQUENCE:
;
;      wavelength_to_rgb
;
;  INPUTS:
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
;      wavelength_to_rgb
;
;  MODIFICATION HISTORY:
;        c. Matt Giguere 2015-05-29T16:23:30
;
;-
function wavelength_to_rgb, $
wavelength, $
gamma_in = gamma_in

if ~keyword_set(gamma_in) then gamma_in = 0.8

red = 0.
green = 0.
blue = 0.

if ((wavelength ge 380.) and (wavelength lt 440.)) then begin
	red = -(wavelength - 440.) / (440. - 380.)
	green = 0.0
	blue = 1.0
endif

if ((wavelength ge 440.) and (wavelength lt 490.)) then begin
	red = 0.
	green = (wavelength - 440.)/(490. - 440.)
	blue = 1.0
endif

if ((wavelength ge 490.) and (wavelength lt 510.)) then begin
	red = 0.
	green = 1.0
	blue = -(wavelength - 510.) / (510. - 490.)
endif

if ((wavelength ge 510.) and (wavelength lt 580.)) then begin
	red = (wavelength - 510.)/(580 - 510.)
	green = 1.0
	blue = 0.
endif

if ((wavelength ge 580.) and (wavelength lt 645.)) then begin
	red = 1.
	green = -(wavelength - 645.)/(645. - 580.)
	blue = 0.
endif

if ((wavelength ge 645.) and (wavelength lt 900.)) then begin
	red = 1.
	green = 0.
	blue = 0.
endif

;let the intensity fall off near the visible limits:
intensity = 1.
if ((wavelength ge 700.) and (wavelength lt 780.)) then begin
	intensity = 0.3 + 0.7 * (780 - wavelength)/(780. - 700.)
endif

if ((wavelength ge 780.) and (wavelength lt 900.)) then begin
	intensity = 0.3 * (900 - wavelength)/(900. - 780.)
endif


if (wavelength lt 420.) then begin
	intensity = 0.3 + 0.7 * (wavelength - 380.)/(420. - 380.)
endif

rgb = [(red * intensity)^gamma_in, $
(green * intensity)^gamma_in, $
(blue * intensity)^gamma_in]

;stop
return, rgb
end;wavelength_to_rgb.pro 