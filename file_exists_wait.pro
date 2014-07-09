pro file_exists_wait, filename
;PURPOSE: To check to make sure a file exists before
; making use of it. This is a sort of remedy for 
; NFS mounts misbehaving. 
; c. 2010.09.28 ~MJG

	fileinf = file_info(filename)
	while ~fileinf.exists do begin
     fileinf = file_info(filename)
	  print, filename, ' DID NOT EXIST!'
	  print, 'The time is now: ', systime()
	  filedirs = strsplit(filename, '/', /extract)
	  spawn, '$ls /'+filedirs[0]
	  PRINT, 'NOW WAITING 3 SECONDS TO SEE IF THE '
	  PRINT, 'NFS MOUNT WILL COME BACK...'
	  wait, 3
	endwhile

end;file_exists_wait.pro