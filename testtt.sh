xmllint --xpath '//*[not(contains(component, "Informix_12.10"))]' plik.xml

xmlstarlet ed -d '//*[component[contains(text(),"Informix_12.10")]]' plik.xml > wynik.xml

use XML::LibXML;

my $parser = XML::LibXML->new();
my $doc = $parser->parse_file('plik.xml');

for my $node ($doc->findnodes('//*[component[contains(text(),"Informix_12.10")]]')) {
    $node->parentNode->removeChild($node);
}

open(my $fh, '>', 'wynik.xml');
print $fh $doc->toString(1);
close($fh);






use XML::LibXML;

my $parser = XML::LibXML->new();
my $doc = $parser->parse_file('plik.xml');

for my $node ($doc->findnodes(
  '//component[contains(@location, "informix_12.10")]'
)) {
    $node->parentNode->removeChild($node);
}

open(my $fh, '>', 'wynik.xml');
print $fh $doc->toString(1);
close($fh);

# === SECURITY HARDENING ===

use XML::LibXML;

my $parser = XML::LibXML->new();
my $doc = $parser->parse_file('plik.xml');

for my $node ($doc->findnodes(
  '//component[
    contains(
      translate(@location,"ABCDEFGHIJKLMNOPQRSTUVWXYZ._","abcdefghijklmnopqrstuvwxyz"),
      "informix1210"
    )
  ]'
)) {
    $node->parentNode->removeChild($node);
}

open(my $fh, '>', 'wynik.xml');
print $fh $doc->toString(1);
close($fh);



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
