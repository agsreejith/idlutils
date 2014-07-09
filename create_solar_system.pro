pro create_solar_system

;cgs:
sun = create_struct( $
'mass', 1.9891d33, $ ;g
'radius', 6.96d10, $ ;cm
'luminosity', 3.9d33, $ ;erg s^-1
'temp', 5.777d3 ) ;K

mercury = create_struct( $
'mass', 3.303d26, $ ;g
'radius', 2.439d8, $ ;cm
'period', 2.4085d-1, $ ;years
'a', 3.87096d-1, $ ;semi-major axis (AU)
'e', 0.205622d) ;eccentricity

venus = create_struct($
'mass', 4.870d27, $ ;g
'radius', 6.050d8, $ ;cm
'period', 6.1521d-1, $ ;years
'a', 7.23342d-1, $ ;semi-major axis (AU)
'e', 0.006783d) ;eccentricity

earth = create_struct($
'mass', 5.976d27, $ ;g
'radius', 6.378d8, $ ;cm
'period', 1.00004d, $ ;years
'a', 9.99987d-1, $ ;semi-major axis (AU)
'e', 0.016684d) ;eccentricity

mars = create_struct($
'mass', 6.418d26, $ ;g
'radius', 3.397d8, $ ;cm
'period', 1.88089d, $ ;years
'a', 1.523705d, $ ;semi-major axis (AU)
'e', 0.093404d) ;eccentricity

jupiter = create_struct($
'mass', 1.899d30, $ ;g
'radius', 7.140d9, $ ;cm
'period', 1.18622d1, $ ;years
'a', 5.204529d, $ ;semi-major axis (AU)
'e', 0.047826d) ;eccentricity

saturn = create_struct($
'mass', 5.686d29, $ ;g
'radius', 6.000d9, $ ;cm
'period', 2.94577d1, $ ;years
'a', 9.575133d, $ ;semi-major axis (AU)
'e', 0.052754d) ;eccentricity

uranus = create_struct($
'mass', 8.66d28, $ ;g
'radius', 2.615d9, $ ;cm
'period', 8.40139d1, $ ;years
'a', 1.930375d1, $ ;semi-major axis (AU)
'e', 0.050363d) ;eccentricity

neptune = create_struct($
'mass', 1.030d29, $ ;g
'radius', 2.43d9, $ ;cm
'period', 1.64793d2, $ ;years
'a', 3.020652d1, $ ;semi-major axis (AU)
'e', 0.004014d) ;eccentricity

pluto = create_struct($
'mass', 1d25, $ ;g
'radius', 1.2d8, $ ;cm
'period', 2.47686d2, $ ;years
'a', 3.991136d1, $ ;semi-major axis (AU)
'e', 0.256695d) ;eccentricity

cgs = create_struct($
'sun', sun, $
'mercurcy', mercury, $
'venus', venus, $
'earth', earth, $
'mars', mars, $
'jupiter', jupiter, $
'saturn', saturn, $
'uranus', uranus, $
'neptune', neptune, $
'pluto', pluto)

system=create_struct('cgs', cgs)

save, system, filename='~/idl/exoidl/data/solarsystem.dat'


end ;create_solar_system.pro