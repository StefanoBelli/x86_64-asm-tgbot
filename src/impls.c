#ifndef TOKEN
#error ABORTING BY DIRECTIVES: you must define a TOKEN!!
#endif

#define _POSIX_C_SOURCE 201112L
#include <openssl/ssl.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netdb.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>

#define MAX_MSG_SIZE BUFSIZ
#define MAX_HTTP_GET_QUERY_SIZE 4096

#define TGHOST "api.telegram.org"
#define HTTPS "https"
#define UAGENT "asmx86bot"

typedef struct essentials {
	int http_success;
	long long chat_id,update_id;
	char message[MAX_MSG_SIZE];
} essentials_t;

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

void _impl_compose_http_get_query(const char* request, char* dest)
{
	snprintf(dest,MAX_HTTP_GET_QUERY_SIZE,
			"GET /bot"TOKEN"/%s HTTP/1.1\r\n \
			User-Agent: "UAGENT"\r\n \
			Connection: close\r\n \
			Host: "TGHOST"\r\n \
			\r\n",
			request);
}

essentials_t _impl_parse_http_response(const char* full)
{
	printf("%s\n",full);
	essentials_t data;
	memset(&data,0,sizeof(essentials_t));

	if (strncmp(full, "HTTP/1.1 200 OK", 15)) {
		data.http_success = 0;
		return data;
	}

	data.http_success = 1;

	char* newpos = strstr(full,"\r\n\r\n");
	if(!newpos)
		return data;

	
	return data;
}

