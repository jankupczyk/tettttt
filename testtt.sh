keytool -genkeypair -alias fqdnmojegoserwera -keyalg RSA -keysize 4096 -validity 365 -keystore fqdnmojegoserwera.jks -storetype JKS -dname "CN=fqdnmojegoserwera,O=organizacja moja,OU=test,L=poznan,ST=wielkopolskie,C=PL,EMAILADDRESS=mojmail@firma.pl" -ext san=dns:fqdnmojegoserwera,email:mojmail@firma.pl



keytool -list -v -keystore fqdnmojegoserwera.jks -storetype JKS -alias fqdnmojegoserwera


keytool -certreq -alias fqdnmojegoserwera -keystore fqdnmojegoserwera.jks -storetype JKS -file fqdnmojegoserwera.csr
