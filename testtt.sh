setenv.sh

#!/bin/sh

CATALINA_OPTS="$CATALINA_OPTS -Dorg.apache.catalina.STRICT_SERVLET_COMPLIANCE=true"
CATALINA_OPTS="$CATALINA_OPTS -Dorg.apache.catalina.connector.RECYCLE_FACADES=true"


server.xml
zmiana numeru portu 8005 na -1 <Server port="-1">


zakomentowac albo usunac wpis
<Realm className="org.apache.catalina.realm.UserDatabaseRealm" resourceName="UserDatabase"/>

w sekcji Engine dodac
<Valve className="org.apache.catalina.valves.RemoteIpValve"
       requestAttributesEnabled="true"
       internalProxies="127\.0\.0\.1" />

       
dać na false sekcje xpoweredBy="false" i dać server="SecureServer" dla każdego connectora



web.xml
w web-app dać

<session-config>
  <cookie-config>
    <secure>true</secure>
    <http-only>true</http-only>
    <same-site>strict</same-site>
  </cookie-config>
</session-config>

dodać do webxml
<error-page>
    <exception-type>java.lang.Throwable</exception-type>
    <location>/error.jsp</location>
</error-page>
