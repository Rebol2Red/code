Red/System [
	Title:  "Windows Ws2_32.dll (Winsock) imports"
	File:   %Ws2_32.reds
	Tabs:   4
	License: {
		Distributed under the Boost Software License, Version 1.0.
		See https://github.com/red/red/blob/master/BSL-License.txt
	}
]
#if OS = 'Windows [

#define WSAPROTOCOL_INFO! int-ptr!
#define GROUP!            integer!
#define SOCKET!           handle!

#enum ADDRESS_FAMILIES! [
;- Address families.
;  Although AF_UNSPEC is defined for backwards compatibility, using
;  AF_UNSPEC for the "af" parameter when creating a socket is STRONGLY
;  DISCOURAGED.  The interpretation of the "protocol" parameter
;  depends on the actual address family chosen.  As environments grow
;  to include more and more address families that use overlapping
;  protocol values there is more and more chance of choosing an
;  undesired address family when AF_UNSPEC is used.
	AF_UNSPEC:       0      ; unspecified
	AF_UNIX:         1      ; local to host (pipes, portals)
	AF_INET:         2      ; internetwork: UDP, TCP, etc.
	AF_IMPLINK:      3      ; arpanet imp addresses
	AF_PUP:          4      ; pup protocols: e.g. BSP
	AF_CHAOS:        5      ; mit CHAOS protocols
	AF_NS:           6      ; XEROX NS protocols
	AF_IPX:          AF_NS  ; IPX protocols: IPX, SPX, etc.
	AF_ISO:          7      ; ISO protocols
	AF_OSI:          AF_ISO ; OSI is ISO
	AF_ECMA:         8      ; european computer manufacturers
	AF_DATAKIT:      9      ; datakit protocols
	AF_CCITT:        10     ; CCITT protocols, X.25 etc
	AF_SNA:          11     ; IBM SNA
	AF_DECnet:       12     ; DECnet
	AF_DLI:          13     ; Direct data link interface
	AF_LAT:          14     ; LAT
	AF_HYLINK:       15     ; NSC Hyperchannel
	AF_APPLETALK:    16     ; AppleTalk
	AF_NETBIOS:      17     ; NetBios-style addresses
	AF_VOICEVIEW:    18     ; VoiceView
	AF_FIREFOX:      19     ; Protocols from Firefox
	AF_UNKNOWN1:     20     ; Somebody is using this!
	AF_BAN:          21     ; Banyan
	AF_ATM:          22     ; Native ATM Services
	AF_INET6:        23     ; Internetwork Version 6
	AF_CLUSTER:      24     ; Microsoft Wolfpack
	AF_12844:        25     ; IEEE 1284.4 WG AF
	AF_IRDA:         26     ; IrDA
	AF_NETDES:       28     ; Network Designers OSI & gateway
]

#enum SOCK_TYPES! [
;- Socket types.
	SOCK_STREAM:    1
	SOCK_DGRAM:     2
	SOCK_RAW:       3
	SOCK_RDM:       4
	SOCK_SEQPACKET: 5
]

#define INADDR_ANY              00000000h
#define INADDR_LOOPBACK         7F000001h
#define INADDR_BROADCAST        FFFFFFFFh
#define INADDR_NONE             FFFFFFFFh

#define SOCKET_ERROR   -1

#define IPPROTO_IP    0

#enum IPPROTO! [
;- Protocols.  The IPv6 defines are specified in RFC 2292.
	IPPROTO_HOPOPTS:  0  ; IPv6 Hop-by-Hop options
	IPPROTO_ICMP:     1
	IPPROTO_IGMP:     2
	IPPROTO_GGP:      3
	IPPROTO_IPV4:     4
	IPPROTO_ST:       5
	IPPROTO_TCP:      6
	IPPROTO_CBT:      7
	IPPROTO_EGP:      8
	IPPROTO_IGP:      9
	IPPROTO_PUP:      12
	IPPROTO_UDP:      17
	IPPROTO_IDP:      22
	IPPROTO_RDP:      27
	IPPROTO_IPV6:     41 ; IPv6 header
	IPPROTO_ROUTING:  43 ; IPv6 Routing header
	IPPROTO_FRAGMENT: 44 ; IPv6 fragmentation header
	IPPROTO_ESP:      50 ; encapsulating security payload
	IPPROTO_AH:       51 ; authentication header
	IPPROTO_ICMPV6:   58 ; ICMPv6
	IPPROTO_NONE:     59 ; IPv6 no next header
	IPPROTO_DSTOPTS:  60 ; IPv6 Destination options
	IPPROTO_ND:       77
	IPPROTO_ICLFXBM:  78
	IPPROTO_PIM:      103
	IPPROTO_PGM:      113
	IPPROTO_L2TP:     115
	IPPROTO_SCTP:     132
	IPPROTO_RAW:      255
	IPPROTO_MAX:      256
]

WSAData!: alias struct! [
;@@ used here just like a placeholder - change once array struct values will be available in Red/System!
	version         [TWO-SHORTS!]   ; wVersion + wHighVersion
;    szDescription   [bytes! 257] ; char szDescription[WSADESCRIPTION_LEN+1];
;    szSystemStatus  [bytes! 129] ; char szSystemStatus[WSASYS_STATUS_LEN+1];
;    maxSocketsUdpDg [integer!]   ; unsigned short iMaxSockets;
;                                 ; unsigned short iMaxUdpDg;
;    lpVendorInfo    [c-string!]  ; char FAR * lpVendorInfo;
] ;- WSAData! size is: 400 bytes

;https://msdn.microsoft.com/en-us/library/windows/desktop/ms740496(v=vs.85).aspx
in_addr!: alias struct! [
	value [integer!]
]

sockaddr!: alias struct! [
	family-port  [TWO-SHORTS!] ; e.g. AF_INET +
							   ; e.g. htons(3490)   
	addr         [in_addr! value] ;
	zero         [float!] ;(bytes 8) zero this if you want to
]
#define sockaddr_in! sockaddr!

#import ["Ws2_32.dll" stdcall [
	bind: "bind" [
		s              [SOCKET!]  ; A descriptor identifying an unbound socket.
		name           [int-ptr!] ; A pointer to a sockaddr structure of the local address to assign to the bound socket.
		namelen        [integer!] ; The length, in bytes, of the value pointed to by the name parameter.
		return:        [integer!] ; If no error occurs, bind returns zero. Otherwise, it returns SOCKET_ERROR
	]
	closesocket: "closesocket" [
		s              [SOCKET!]
		return:        [integer!] ; If no error occurs, bind returns zero. Otherwise, it returns SOCKET_ERROR
	]
	htons: "htons" [
	;converts a u_short from host to TCP/IP network byte order (which is big-endian).
		;@@ FIXME once we will have int16! type in Red
		hostshort      [integer!] ;uint16!
		return:        [integer!] ;uint16!
	]
	inet_addr: "inet_addr" [
	;converts a string containing an IPv4 dotted-decimal address into a proper address for the IN_ADDR structure.
		adress         [c-string!]
		return:        [in_addr! value]
	]
	inet_ntoa: "inet_ntoa" [
		address        [in_addr! value]
		return:        [c-string!]
	]
	ntohs: "ntohs" [
	;converts a u_short from TCP/IP network byte order to host byte order (which is little-endian on Intel processors).
		;@@ FIXME once we will have int16! type in Red
		netshort      [integer!] ;uint16!
		return:        [integer!] ;uint16!
	]
	recvfrom: "recvfrom" [
		s              [SOCKET!]
		buf            [byte-ptr!]
		len            [integer!]
		flags          [integer!]
		from           [sockaddr_in!]
		fromlen        [int-ptr!]
		return:        [integer!]
	]
	sendto: "sendto" [
		s              [SOCKET!]
		buf            [byte-ptr!]
		len            [integer!]
		flags          [integer!]
		to             [sockaddr!]
		tolen          [integer!] ;= 16 -> size of sockaddr!
		return:        [integer!]
	]
	WSACleanup: "WSACleanup" [
		return: [integer!]
	]
	WSAGetLastError: "WSAGetLastError" [
		return: [integer!]
	]
	WSASocket: "WSASocketW" [
		af             [integer!]          ; address family specification
		type           [integer!]          ; type specification for the new socket
		protocol       [integer!]          ; If a value of 0 is specified, the caller does not wish to specify a protocol and the service provider will choose the protocol to use.
		lpProtocolInfo [WSAPROTOCOL_INFO!] ; characteristics of the socket to be created
		group          [GROUP!]            ; An existing socket group ID or an appropriate action to take when creating a new socket and a new socket group.
		dwFlag         [integer!]          ; A set of flags used to specify additional socket attributes.
		return:        [SOCKET!]           
	]
	WSAStartup: "WSAStartup" [
		wVersionRequested [int16-value!] ;@@ short!
		lpWSAData         [WSAData!]
		return: [integer!]
	]
]]

]