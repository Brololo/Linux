echo "192.168.1.11 node1.tp2.b2" > /etc/hosts

echo "-----BEGIN CERTIFICATE-----
MIIDATCCAemgAwIBAgIJAOSe/OBi5TdRMA0GCSqGSIb3DQEBCwUAMBcxFTATBgNV
BAMMDG5vZGUxLnRwMi5iMjAeFw0yMDA5MzAxNDQyNTRaFw0yMTA5MzAxNDQyNTRa
MBcxFTATBgNVBAMMDG5vZGUxLnRwMi5iMjCCASIwDQYJKoZIhvcNAQEBBQADggEP
ADCCAQoCggEBAL368ZScDkqrmyaMZICN7sdCBSMr9BTiBKEQCz9vGdefb9WiicPC
nD4N7c0ubrK0X2mdXh0t/74o2VyYTEt5b1qi8l2LmNev+Tgh/WlYDcqXerqDkm76
zOGmCzn8QS2fwoQ7MzwCYo/ZTfzgLNx05YUIbL2LroZ8ilf8ugzQzZXvAJRmZpuu
Cwo72BSNg1wUrBeWctAnRtuPjIvt1T48YELxTpJtJCBJyZcyHqpxdYsOm+8DDZ05
0qocDEFxl0kJs/N0C9cJHW/op1M6iBEs66bgZqMjNJLSxbgldVBwluuQvz1qO9kK
evG7iUhPueNa7soa4hwstmrDAD/Ic2mSGykCAwEAAaNQME4wHQYDVR0OBBYEFA9o
E8WczL9YKXAsbWWUzF2bkl/+MB8GA1UdIwQYMBaAFA9oE8WczL9YKXAsbWWUzF2b
kl/+MAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQELBQADggEBADIylVOKf8Vn6KZv
C2PMLCdyb3zIOdFaZb2FwQQbQjP8a5wGjTk48+g0+yJ4JeJqRKQocC/x7czJdkz6
Xg8Sk6KR742kvQZU3xtJSohFiUHjscaDWEbGSJEt9fjuo97x+frXhHhmB40zaOvu
kldTYMrbnyOMadZSKafv0Vc98fainsnclZcTv3YCeimFFcNlYrsLRSzaU39pjSht
ZqoDtFDjbkaAEoaoXtl7MzC5q0BPs3Md/2KH+CF4QArspqvoShw11OaLw1DE66ZS
h6RQsFqcuLMh3dM2C8WgivFWehRyfYGl587ZJzUn95eUOFuMKGjRUHJVfkJI1i4i
IkDgY9M=
-----END CERTIFICATE-----" > /etc/pki/ca-trust/source/anchors/node1.tp2.b2.crt

update-ca-trust