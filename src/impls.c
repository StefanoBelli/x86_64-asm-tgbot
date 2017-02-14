#define _POSIX_C_SOURCE 201112L
#include <openssl/ssl.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netdb.h>
#include <string.h>
#include <unistd.h>

#define TGHOST "api.telegram.org"
#define HTTPS "https"

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
}

