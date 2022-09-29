# Networking Notes

## Layers

- OSI Model: Open Systems Interconnect
    – A network model developed in the 70’s.
    - Each layer uses lower layers, lower layers know nothing about upper layers.
    - So http is actually http-tcp-ip-ethernet
- 7 Application: Reformats data for program usage.
    - Web: http/https -  An application layer protocol for the Web based on a request-response model. It operates at a higher level and slower level than the network. Resources are identified by URL.
    - URL: An address that shows where a page resides on the Web. It’s made up of a protocol, host name, and path. The host gets resolved to an IP address.
    - Domain: DNS lets us use simple names instead of IP’s.
    - File: ftp (Filezilla is good), sftp, tftp, smb (Windows)
    - Email: pop3, imap, smtp (Thunderbird is good)
    - Authentication: ldap, ldaps (Client Windows  connects to Active Directory Server)
    - Network Services (moves data): DHCP configures IP for you
    - Time: NTP server configures all clients with correct time
    - Network Management (remote login): 
    -   Telnet – unencrypted
    -   SSH – encrypted,
    -   SNMP – crawls your SNMP network
    -   RDP – allows you to remote desktop by substituting an IP
    -   Audio / Visual – H.323 for video conferencing, SIP for telephones
- 6 Presentation (OLD): ASCII, EBCDIC, rarely used
- 5 Session (OLD): CITRIX ICA, sets up an application server, rarely used
- 4 Trans: TCP, UDP, Ports. Sets up sessions
   - TCP: like setting up a specific call, with hellos, continued conversation, and goodbyes, called handshake and disconnect.
   - UDP: like quick shout out to your roommates, hoping for a response, unreliable, but useful for short comms like DNS.
   - Port: A number to identify different services running on the same server. 
        - For UDP and TCP numbers range from 0 to 65353 (~2**16)
        - Ephemeral client port will connect to a well known server port
        - 0 – 1023: Well known ports, used by common services
        - 1024 – 49151: Registered (can’t be duplicated) ports typically used by server apps.
        - 49152 – 65353: Dynamic / private ports are ephemeral, typically used by client apps.
- 3 Net: Packets IP Addresses, IP Routing, like a phone number, or address
    - Ping:	A network utility that tests the reachability of a host on an Internet Protocol (IP) network using the Internet Control Message Protocol (ICMP). Ping operates at the network level, which is a lower and faster level, than an http. Resources are identified by IP address. IP and ICMP do not support the concept of ports.
- 2 Data Link: Frames, Switch, Hub, Ethernet, DOCSIS-3 Protocol (may be wired or unwired), only moves data between the Hardware
- 1 Physical: Cables, Router, Hardware


## Tools by Layer

- 7: 
    - telnet (rlogin) 
    - ssh (encrypted rlogin), 
    - snmp (network tool), 
    - rdp (screen share login)
    - ftp on browser (browse to ftp://yourftpserver)
    - filezilla (file transfer)
    - thunderbird (email)
    - windows - map network drive (windows files transfer)
    - nslookup (query dns)
- 6: na
- 5: na
- 4: na
- 3: 
    - ipconfig (show my ip),
    - ping 8.8.8.8 (check if ip host is alive), 
    - traceroute -d 8.8.8.8 (show routers to my dest), 
- 2: arp -a (show table of ips and macs)
- 1: NA


## Devices

- Hub: layer 2, repeats frames to all connected devices, dumb device, no config, used to create a local network
- Switch: layer 2, passes on frames only to addressed devices, smart version of a hub, no config, used to create a local network
- Router / Gateway: layer 3, forwards packets toward their destination, smart, requires config, used to traverse networks


## IP Addressing

- subnet mask: a way to distinguish the network and host portion of an ip 
    address using ones for the network and zeros for the host. You can also
    think of it as a prefix mask
- cidr notation: writing the subnet mask as the number of prefix digits
- classless addressing: when an address includes prefix / subnet mask to
    identify the network and host portionn
- network address: host portion is all zeroes. id's a group of hosts
- host address: host portion is neither all zeroes or all ones. id's a specific host
- broadcast address: host portion is all ones, id's all the hosts
- private ips: 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16 127.0.0.1 (home)
- gateway = router.


## Subnetting Networks

- Definition: breaking networks into smaller networks
- The "/" Notation is called CIDR (Classless Interdomain Routing) Notation.
- The purpose is to identify a sub-network or submet.
- Example) The IP address had 256*4 possibities (255.255.255.255 would be the last possility)
- Example) 10.0.0.0/24 Says 10.0.0 is the SUBNET.
    - 0 is reserved for the name for the network.
    - 255 is reserved for broadcast messaging.
    - 1-254 or 10.0.0.1 - 10.0.0.254 are the possible hosts.
- variable length submet masking (VLSM): normally networks are deployed by 
    breaking into smaller networks. By moving the mask you change the size of
    the network. 10.0.0.0/8 provides ~16 million hosts, but 10.0.0.0/24 provides ~256
- Advanced subnetting - take Pluralsight's Network Layer Addressing and 
    Operation for CISCO CCNA 200-125/100-105 


## IPv6

- Definitions: 
    - Bit: 0 or 1
    - Nibble: 4 bits
    - Byte: 8 bits
    - Hextet: 16 bits
- IPv4: 32 bits writtten in 4 decimal octets
- IPv6: 128 bits written in 8 hextets
- Network Portion and Interface Portion are usually both 64 bits, designated 
    as /64 (cidr notation), but is usually omitted
- Leading zeroes are typically omitted: 
    2001:0DB8:0002:008D:0000:0000:00A5:52F5 -> 2001:DB8:2:8D:0:0:A5:52F5
- All zeroes are shortened to one double colon (::) per address,
    usually written at the beginning of the host portion
    2001:DB8:2:8D:0:0:A5:52F5 -> 2001:DB8:2:8D::A5:52F5
- There's no private addressing
- Machines require two addresses:
    1. IPv6: External Address
    2. Link-local IPv6 Address: like a MAC address, a local only identifier, usually self configured
- Address Acquisition Option 1: SLAAC - Stateless Address Auto-configuration
    - router advertises itself, Windows devices then will pick random 64bits, Uni*x modify it's MAC address.
    That value gets added to network portion to complete the address.
- Address Acquisition Option 2: DHCP. Same as normal DHCP. Client asks for address, server gives address, but wth IPv6
- Tunneling IPv6: Not common. Inet backbone uses IPv6, but can't access it easily


## IP Routing

- OSI Layer 3 Networking
- Network Layer responsible for end-to-end communication.
- Router - shown as circle with 4 arrows pointing in opposite directions. Router's direct frames to where they need to go by looking at the packet source IP and destination IP.
- IP Packet: Source IP + Dest IP, Time To Live (TTL - prevents loops), Other
- IP Packet gets wrapped by the Frame; Layer 2 wraps Layer 3
- Address Resolution Protocol (ARP): Translates Layer 3 to Layer 2. IP -> MAC. Before a frame can go out, it needs to have a destination mac address. ARP first sends out a broadcast message to get dest mac. Now the frame is complete, and the switch can direct the message properly. ARP tables are not the same MAC address tables! Devices keep an ARP cache / table for about 90 seconds. Arp only works on LAN. Routers will throw away an ARP for different LAN. So solution is to arp the default gateway / router, since that's responsible for all outside lan traffic.
- Separate topic: a Mac Address table is pure layer 2. It exists only on a switch. It maps MACs to ports.
- Router = Gateway, Gateway = Router
- Default gateway: ARP will only work on LAN, when it can't find the IP, it sends to the Default Router / Default Gateway. From their the process starts again.
- Routing table / RIB (routing information base) - most importantly stores a network destination ip address, and it's next hop. Simile: You need to go to a small town, in a small country, on a different continent. The routing table will have your small town, and the next hop, in first case - the continent. Once at the continent, the routing table will indicate the country, and so on.
- Routing Tables include physically connected devices.
- Routing protocols can be static or dynamic.


## Ethernet

- OSI Layer 2, Datalink
- Describes a protocol, wired or not wired does not matter.
- Mac Address / Physical Address: 48 bits ID, assigned at manufacturing, 24 bits are the Manufacturers ID, 24 bits are the serial #.
- Protocol: CSMA/CD Carrier Sense Multiple Access with Collision Detection.
    Line sends out 5V signals, if there's ever 10V, all devices know there a
    collision, wait a random amount of time, and resend message
- Half Duplex (old): like a Walk talkie - only talk or listen at one time, there are collisions
- Full Duplex (modern): like a telephone - talking and listening at the same time ok, there are no collisions
- Speed: 10 Mbps original, 1Gbps common, 40Gbps max right now
- Frame (Ethernet 2 Frame): a chunk of data consisting of mac headers and data, specifically
    48bit Dest Mac, 48bit Source Mac, 16bit Type (Data Type), a maximum 1500 Byte Data Packet (Usually IP), 16bit Frame Check Sequence (FCS: validation calculation)
- Hub: a repeater. Ex) device sends message to hub, hub repeats message to all devices, gets collisions
- Switch: makes a table of ports and mac addresses, receives messages, checks table, sends messages to destination only. reduces traffic, reduces collisions
- Topologies
    - Bus: one line, popular in 90's, rare now
    - Ring: circular line, not popular, IBM made expensive
    - Star: hub and spoke, popular now
- Broadcast Messages: 
    - Layer 2, different thatn layer 3 IP Broadcast. 
    - When destination MAC is all F's, the swtich will recreate the message for all devices (act like a hub)


## Switching Features

- OSI Layer 2 Data Link
- Connecting Switches: If you connect two switches bidrectionally you get feedback loops, called Broadcast Storms.
- Spanning Tree Protocol: Enterprise switches solve the problem above by detecting redundancies, and shutting down the appropriate ports. Home switches do not do this
- Broadcast Domain = VLAN
- Virtual Local Area Network (VLAN) - One physical switch can be setup as multiple logical networks (up to 4000!) or you can use multiple switches.  This is especially useful for data centers, where each VLAN 
- VLAN Tags and trunks - When you use two physical switches. The link between those is called a trunk link. Only those ports between the switches gets an extra VLAN header. One the frame passes the trunk, the tag is removed. Ports are called tagged / trunk ports, or untagged / access ports depending in on manufacturer.
- Switch port mirroring. Tee traffic from switch for analysis. Wireshark is a popular tool. 
- Power over Ethernet (PoE). Ethernet can deliver power. 802.3at standard provides 25.5 Watts DC power. Saves money. 


## Network Services

- Network Name Variations
    - LAN: Every device inside of a router, including the router, including the WLAN
    - WLAN: Every device connected to a wireless router
    - WAN: Wide area network - functional network separated by multiple routers, example) a company network may use two LAN's because they are in multiple buildings.
    - CAN: Campus Area Network: a university network
    - MAN: Metropolitan Area Network: a city network
    - SAN: Storage Area Network: a network of a harddrive array.
    - PAN: Personal Area Network: a bluetooth network 
- Network Address Translation: router will not send private packets to the internet, so NAT substitues an external IP for the private IP, and keeps a table of the substitutions for return IPs.
- Port Forwarding: a form of NAT that uses Source Socket and Destination Socket - Ports are appended to the IP. Ex) 10.0.0.10 -> 10.0.0.10/9293
- Access Control Lists: A router black lists for IP's. Ex) Deny 198.51.100.5, Allow Other Traffic
- Traffic Shaping: Prioritizes network traffic. Ex) Phone calls should be prioritized over web traffic. Layer 2 and Layer 3 devices can be configured to prioritize traffic based Quality of Service (QoS) or Class of Service (CoS)
- Dynamic Host Configuration Protocol (DHCP): Layer 7. Home routers set this up for us, before enterprise usually has a dedicated DHCP server with it's own IP. Server's automatically discover and assign IP's to devices. Manual setup requires an IP, Subnet Mask, and Default Gateway. 
- DNS Heirarchy: Example) www.shop.nike.com, top level (com), 2nd level (nike), 3rd level (shop), host (www). The whole idea is that a public DNS server will consult it's cache, then the top level DNS server first, then 2nd level, and so on to get authoritative name server. Then get the IP from authoritative server.
- Forward DNS Lookup: url -> ip
- Reverse DNS Lookup: ip -> url, must be configured, and may be explicity denied.
- Internal DNS Servers: url -> ip, set up as primary DNS, then unknown hosts forwarded to exteral DNS

## Networking Scanning
- A technique for identifying **devices**
- Devices have a IPs and MAC addersses
- IP's have TCP and UDP ports: 1-65,535
- Ports can be open, close, filtered, or unfiltered
- Ports run OS & Services


##  Common Ports
- 21 FTP
- 22 SSH
- 23 Telnet
- 25 SMTP
- 53 DNS
- 80 HTTP
- 88 Kerberos
- 110 POP3
- 111 NIX
- 135 RPC
- 139 SMB (old)
- 143 IMAP4
- 161 SNMP
- 162 SNMP traps
- 389 LDAP
- 443 HTTPS
- 445 SMB
- 3389 RDP

## NNMAP
- Scans IP's, Hosts, Ports
- Service discovery
- OS, Version Detection
- Info on target, reverse DNS names, device types, and MAC addresses
- `nnap [Type] [Options] <target>`
- `nmap -sS -p 22 192.168.1.0` silent SYN scan port 22 of IP 192.168.1.0
- Target can Single IP, Host example.com, subnet example.com/24, range 192.168.1.1-50
- Type: -sP Hosts up, -sS SYN or 1/2 Scan of Ports, -sT Full Connect Scan of Ports, -A Everything: OS, Service, Script, & Traceroute
