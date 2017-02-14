#include <openssl/ssl.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netdb.h>
#include <string.h>

#define TGHOST "api.telegram.org"
#define HTTPS "https"

struct address_info {
    socklen_t len;
    struct sockaddr* address;
};

void _impl_OpenSSL_add_all_algorithms() 
{
	OpenSSL_add_all_algorithms();
}

struct address_info _impl_get_tghost_addr()
{
   struct addrinfo hints, *query_res;
   memset(&hints,0, sizeof(struct addrinfo));
   
   hints.ai_family=AF_INET;
   hints.ai_socktype=SOCK_STREAM;

   getaddrinfo(TGHOST,HTTPS,&hints,&query_res);

   struct address_info infoaddr;
   memset(&infoaddr,0,sizeof(struct address_info));

   infoaddr.address=query_res->ai_addr[0];
   infoaddr.len=query_res->ai_addrlen;
   
   freeaddrinfo(query_res);
   return infoaddr;
}