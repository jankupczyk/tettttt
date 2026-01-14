<VirtualHost *:443>
    ServerName localhost
    DocumentRoot "D:/xampp/htdocs/DOCROOT/public"

    SSLEngine on
    SSLCertificateFile "D:/xampp/apache/conf/ssl.crt/server.crt"
    SSLCertificateKeyFile "D:/xampp/apache/conf/ssl.key/server_nopass.key"
    SSLCertificateChainFile "D:/xampp/apache/conf/ssl.crt/chain.crt"

    SSLProtocol -all +TLSv1.2 +TLSv1.3
    SSLCipherSuite TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
    SSLHonorCipherOrder on

    LimitRequestBody 10485760


    Header always set Strict-Transport-Security "max-age=31536000"

    Header always set X-Content-Type-Options "nosniff"
    Header always set X-Frame-Options "DENY"
    Header always set X-XSS-Protection "1; mode=block"
    Header always set Referrer-Policy "strict-origin-when-cross-origin"

    <Directory "D:/xampp/htdocs/DOCROOT/public">
        AllowOverride All
        Require all granted
        <LimitExcept GET POST>
            Deny from all
        </LimitExcept>
    </Directory>

    ErrorLog "logs/ssl_error.log"
    CustomLog "logs/ssl_access.log" combined

</VirtualHost>
