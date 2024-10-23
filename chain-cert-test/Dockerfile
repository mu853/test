FROM nginx:alpine

COPY ssl.conf /etc/nginx/conf.d/ssl.conf

RUN mkdir -p /etc/nginx/ssl
COPY ca/server.crt /etc/nginx/ssl/server.crt
COPY ca/server2.crt /etc/nginx/ssl/server2.crt
COPY ca/server.key /etc/nginx/ssl/server.key
COPY ca/ca-chain.pem /etc/nginx/ssl/ca-chain.pem
COPY ca/all-chain.pem /etc/nginx/ssl/all-chain.pem
COPY ca/all-chain2.pem /etc/nginx/ssl/all-chain2.pem
COPY ca/all-chain-reverse.pem /etc/nginx/ssl/all-chain-reverse.pem
COPY ca/all-chain-reverse2.pem /etc/nginx/ssl/all-chain-reverse2.pem

RUN chmod 600 /etc/nginx/ssl/server.key
