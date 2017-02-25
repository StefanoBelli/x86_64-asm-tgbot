#ifndef TOKEN
#error ABORTING BY DIRECTIVES: you must define a TOKEN!!
#endif

#define _POSIX_C_SOURCE 201112L
#include <openssl/ssl.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netdb.h>
#include <netinet/tcp.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>

#define MAX_HTTP_GET_QUERY_SIZE 4096
#define MAX_BOTOP_SIZE 100

#define TGHOST "api.telegram.org"
#define HTTPS "https"
#define UAGENT "asmx86bot"
#define BOTOP_GETUPDATES_TIMEOUT "30"

void _impl_OpenSSL_add_all_algorithms() 
{
	OpenSSL_add_all_algorithms();
}

int _impl_resolve_and_connect(int sockfd)
{
   struct addrinfo hints, *query_res;
   memset(&hints,0, sizeof(struct addrinfo));
   
   hints.ai_family=AF_UNSPEC;
   hints.ai_socktype=SOCK_STREAM;

   if(getaddrinfo(TGHOST,HTTPS,&hints,&query_res) != 0) 
		return -1;
   
	if(connect(sockfd,query_res->ai_addr,query_res->ai_addrlen) == -1) {
		freeaddrinfo(query_res);
		return -1;
	}

   freeaddrinfo(query_res);
   return 0;
}

void _impl_daemon() 
{
	if(fork())
		exit(0);

	if(setsid() < 0)
		exit(1);
	
	close(0);
	close(1);
	close(2);
}

void _impl_compose_http_get_query(const char* request, char* dest)
{
	snprintf(dest,MAX_HTTP_GET_QUERY_SIZE,
			"GET /bot"TOKEN"/%s HTTP/1.1\r\n"
			"User-Agent: "UAGENT"\r\n"
			"Host: "TGHOST"\r\n"
			"\r\n",
			request);
	//printf("HEADER BYTES: %d\nHEADER CONTAINS: %s\n==",strlen(dest),dest);
}

void _impl_get_value_from_kvpair(const char* resp, const char *sep, char* dest)
{
	int i=0;

	while(resp[i] != *sep) {
		dest[i] = resp[i];
		i++;
	}
	
	dest[i]=0;
}

void _impl_getupdates_botop(const char* off, char* dest)
{
	snprintf(dest,MAX_BOTOP_SIZE,"getUpdates?timeout="BOTOP_GETUPDATES_TIMEOUT"&offset=%s&limit=1",off);
}

//void _impl_sendmessage_botop(...)

void _impl_ltoa(long n, char* ntoa)
{
	sprintf(ntoa,"%ld",n);
}

int _impl_enable_tcp_keepalive(int sockfd) 
{
	int enabled = 1, probe_intvl = 67;
	socklen_t optsize = sizeof(int);

	if(setsockopt(sockfd,SOL_SOCKET,SO_KEEPALIVE,&enabled,optsize) == -1)
		return 1;
	if(setsockopt(sockfd,IPPROTO_TCP,TCP_KEEPINTVL,&probe_intvl,optsize) == -1)
		return 1;

	return 0;
}
