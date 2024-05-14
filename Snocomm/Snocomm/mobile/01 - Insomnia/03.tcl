source "02.tcl"

set localSystem {	
	# autenticación
					autoproxy
					coreautha
					coreauthd
					dbmanage
					htdigest
					htpasswd
					ssh-add
					ssh-agent
					ssh-keygen
					ssh-keysign
	# teclado
					grab
					khim
					term_bind
					set dispatchFromTerminals {term::receive::bind}
	# red inalámbrica
					WiFiAgent
					WiFiVelocityAgent
					wifiFirmwareLoader
					wifid
					wifivelocityd
	# fotografías
					cloudphotosd
	
	# directorios del contenedor
					APFSUserAgent
					container
					doctools::toc
					pt_peg_container
					pt_peg_container_peg
					pt_peg_export_container
					pt_peg_to_container
					ttk::frame
					ttk::labelframe
					ttk::notebook
					ttk::panedwindow
				}