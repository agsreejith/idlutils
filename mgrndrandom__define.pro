; docformat = 'rst'

;+
; Read from an URL (with error checking).
;
; :Returns: strarr
; :Params:
;    `urlString` : in. required, type=string
;       complete URL to query
; :Keywords:
;    `error` : out, optional, type=long
;       pass a named variable to get the response code: 0 for success, 
;       anything else indicates a failure
;-
function mgrndrandom::_getData, urlString, error=error
  compile_opt strictarr
  
  error = 0L
  catch, error
  if (error ne 0L) then begin
    catch, /cancel
    self.url->getProperty, response_code=error
    return, ''
  endif
  
  return, self.url->get(url=urlString, /string_array)
end


;+
; Returns a permutation of the given range of integers.
; 
; :Returns: lonarr
; :Keywords:
;    `minimum` : in, optional, type=long, default=0
;       minimum value of returned integers
;    `maximum` : in, optional, type=long, default=100
;       maximum value of returned integers
;    `error` : out, optional, type=long
;       pass a named variable to get the response code: 0 for success, 
;       anything else indicates a failure
;-
function mgrndrandom::getSequence, minimum=minimum, maximum=maximum, $
                                   error=error
  compile_opt strictarr
  
  myMinimum = n_elements(minimum) eq 0 ? 0 : minimum
  myMaximum = n_elements(maximum) eq 0 ? 100 : maximum
  
  urlString = self.randomURL $
                + '/sequences/?' $
                + 'min=' + strtrim(myMinimum, 2) $
                + '&max=' + strtrim(myMaximum, 2) $
                + '&format=plain&rnd=new'
  
  result = self->_getData(urlString, error=error)
  
  return, long(result)
end


;+
; Return the given number of random integers (with repetition).
;
; :Returns: lonarr
; :Params:
;    `number` : in, required, type=long
;       number of random numbers to generate
; :Keywords:
;    `minimum` : in, optional, type=long, default=0
;       minimum value of returned integers
;    `maximum` : in, optional, type=long, default=100
;       maximum value of returned integers
;    `error` : out, optional, type=long
;       pass a named variable to get the response code: 0 for success, 
;       anything else indicates a failure
;-
function mgrndrandom::getIntegers, number, minimum=minimum, maximum=maximum, $
                                   error=error
  compile_opt strictarr
  on_error, 2
  
  if (n_elements(number) eq 0) then begin
    message, 'number parameter required'
  endif
  
  myMinimum = n_elements(minimum) eq 0 ? 0 : minimum
  myMaximum = n_elements(maximum) eq 0 ? 100 : maximum
  
  
  urlString = self.randomURL $
                + '/integers/?' $
                + 'num=' + strtrim(number, 2) $
                + '&min=' + strtrim(myMinimum, 2) $
                + '&max=' + strtrim(myMaximum, 2) $
                + '&col=1&base=10&format=plain&rnd=new'
  
  result = self->_getData(urlString, error=error)
    
  return, long(result)
end


;+
; Free resources.
;-
pro mgrndrandom::cleanup
  compile_opt strictarr
  
  obj_destroy, self.url
end
 

;+
; Creates a random number generator.
;
; :Returns: 1 if success, 0 if failure
;-
function mgrndrandom::init
  compile_opt strictarr
  
  self.url = obj_new('IDLnetURL')  
  self.randomURL = 'http://random.org'
  
  return, 1
end


;+
; :Fields:
;    `randomURL` URL of the random.org website which generates the random 
;       numbers
;-
pro mgrndrandom__define
  compile_opt strictarr
  
  define = { MGrndRandom, $
             url: obj_new(), $
             randomURL: '' $
           }
end