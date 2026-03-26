$ENV{'INFORMIXDIR'}    ||= '/opt/informix';   # ścieżka do Informix
$ENV{'INFORMIXSERVER'} ||= 'informix';       # nazwa serwera
$ENV{'PATH'} = "$ENV{INFORMIXDIR}/bin:$ENV{PATH}";
