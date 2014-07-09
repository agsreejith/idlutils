;***********************************************************************
; NAME: ASTR
;																	   
; PURPOSE: The purpose of this procedure is to print out all of the
;		useful astronomical constants and create variables that house
;		them for solving problems. 
;
;																	   
; CATEGORY: UTIL
;																	   
; CALLING SEQUENCE:													   
;																	   
;																	   
; INPUTS:															   
;
; OPTIONAL INPUTS:													   
;																	   
; KEYWORD PARAMETERS:	
;
; OUTPUTS:															   
;																	   
; OPTIONAL OUTPUTS:													   
;																	   
; SIDE EFFECTS:														   
;																	   
; RESTRICTIONS:														   
;																	   
; PROCEDURE:														   
;																	   
; EXAMPLE:			
;																	   
; MODIFICATION HISTORY:												   
;     c. Matt Giguere, Tuesday, May 20, 2008		
;***********************************************************************
pro astr

au2m = 1.49598d11
G = 6.673d-11 ; m^3 kg^-1 s^-2
Msol = 1.98892d30 ;kg
kbJK = 1.3806503d-23 ; J K^-1
kbeVK = 8.617342d-5 ; eV K^-1
mp = 1.67262158d-27 ;kg
yr2secs = 3.1556926d7 
m_earth2m_jup = 0.00314646864d
ly2m = 9.4605284d15 ;1 light-year in meters
c = 2.99792458d8 ;m s^-1
melec = 9.10938188d-31 ;kg
qelec = 1.60217646d-19 ;C
J2eV = 1d/1.602176462d-19

rearth = 6.3781d6 ;m
mearth = 5.9742d14 ;kg

rjup = 7.1492d7 ;m
mjup = 1.8987d27 ;kg

sbcon = 5.670400d-8 ;W m^-2 K^-4
sbeV = 8.617343d-5

rsun = 6.955d8 ;m
msun = 1.98892d30 ;kg

alph = 7.56d-16 ;J m^-3 K^-4 (Ryden p. 20 energy density eps = alph*T^4)


print, ''
print, '----------------------------------------------------------------------------'
print, ' DESCRIPTION OF VARIABLE    |      UNITS       |  VARNAME     |    VALUE   '
print, '----------------------------------------------------------------------------'
print, '       1 AU in meters       |  DIMENSIONLESS   |   au2m       | ', au2m
print, '       1 ly in meters       |  DIMENSIONLESS   |   au2m       | ', ly2m
print, '     1 Year in Seconds      |  DIMENSIONLESS   |  yr2secs     | ', yr2secs
print, '     Joules to eV           |  DIMENSIONLESS   |    J2eV      | ', J2eV
print, '     M_E 2 M_JUP            |  DIMENSIONLESS   |m_earth2m_jup | ', m_earth2m_jup
print, '     Mass of Sun            |       kg         |    Msol      | ', Msol
print, '      Proton Mass           |       kg         |     mp       | ', mp
print, '     SPEED OF LIGHT         |      m s-1       |     c        | ', c
print, '  GRAVITATIONAL CONSTANT    |   m^3 kg^-1 s-2  |     G        | ', G
print, "   BOLTZMANN'S CONSTANT     |      J K^-1      |     kb       | ", kb
print, '  STEF-BOLTZ CONST          |   W m^-2 K^-4    |    sbcon     | ', sbcon
print, '  STEF-BOLTZ CONST (eV)     |   W m^-2 K^-4    |    sbeV      | ', sbeV
print, '       BOLTZ CONST  (J)     |         J K^-1   |    kbJK      | ', kbJK
print, '       BOLTZ CONST (eV)     |        eV K^-1   |    kbeVK     | ', kbeVK
print, '            alph            |   J m^-3 K^-4    |     alph     | ', alph
print, '----------------------------------------------------------------------------'
print, ''

stop
end ;phys.pro