# === SECURITY HARDENING ===

# Limit request body (DoS protection)
LimitRequestBody 10485760

# Request timeouts (Slowloris protection)
RequestReadTimeout header=20-40,MinRate=500 body=20,MinRate=500

# Global timeout
TimeOut 120

# KeepAlive settings
KeepAlive On
MaxKeepAliveRequests 100
KeepAliveTimeout 5

# Hide server details
ServerTokens Prod
ServerSignature Off

# Logging format
LogFormat "%h %l %u %t \"%r\" %>s %b" combined
CustomLog logs/access_log combined

# Disable risky options on root
<Directory />
    Options None
    AllowOverride None
</Directory>

# Basic header sanity (requires mod_headers)
<IfModule mod_headers.c>
    Header always unset X-Powered-By
</IfModule>
