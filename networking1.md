Ping	A network utility that tests the reachability of a host on an Internet Protocol (IP) network using the Internet Control Message Protocol (ICMP). Ping operates at the network level, which is a lower and faster level, than an http. Resources are identified by IP address. IP and ICMP do not support the concept of ports.
Port	A number to identify different services running on the same server. For UDP and TCP numbers range from 0 to 65353 (~2**16)
0 – 1023: Well known ports, used by common services
1024 – 49151: Registered (can’t be duplicated) ports typically used by server apps.
49152 – 65353: Dynamic / private ports are ephemeral, typically used by client apps.
TCP	A web protocol which supports ports
UDP	A simple web protocol which supports ports
Http 	An application layer protocol for the Web based on a request-response model. It operates at a higher level and slower level than the network. Resources are identified by URL.
URL	An address that shows where a page resides on the Web. It’s made up of a protocol, host name, and path. The host gets resolved to an IP address.
Network tools to test a port	telnet, netcat/nc, nmap, ncat, curl
OSI Model	Open Systems Interconnect – A network model developed in the 70’s.
Each layer uses lower layers. So http is actually http-tcp-with-port-ip
7 Application: Reformats data for program usage.
  Web: http/https
  File: ftp (Filezilla is good), sftp, tftp, smb (Windows)
  Email: pop3, imap, smtp (Thunderbird is good)
  Authentication: ldap, ldaps (Client Windows  connects to Active Directory Server)
  Network Services (moves data): DHCP configures IP for you
  Domain: DNS lets us use simple names instead of IP’s.
    (use nslookup)
  Time: NTP server configures all clients with correct time
  Network Management (remote login): 
    Telnet – unencrypted
    SSH – encrypted,
    SNMP – crawls your SNMP network
    RDP – allows you to remote desktop by substituting an IP
    Audio / Visual – H.323 for video conferencing, SIP for telephones
6 Presentation (OLD): ASCII, EBCDIC (old), rarely used
5 Session (OLD): CITRIX ICA, sets up an application server, rarely used
4 Transport: TCP, UDP, Ports. Sets up sessions
   TCP: like setting up a specific call, with hellos, continued conversation, and goodbyes, called handshake and disconnect.
   UDP: like quick shout out to your roommates, hoping for a response, unreliable, but useful for short comms like DNS.
   Ports: Ephemeral client port will connect to a well known server port
3 Network: IP Addresses, IP Routing, like a phone number, or address
2 Data Link: Ethernet, DOCSIS-3 Protocol (may be wired or unwired), only moves data between the Hardware
1 Physical: Cables, Router, Hardware
