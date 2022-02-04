FROM alpine

RUN apk add -U \
	zerotier-one \
	&& rm -rf /var/cache/apk/*

ADD entrypoint.sh .
RUN chmod +x entrypoint.sh 

CMD ["/entrypoint.sh"]

EXPOSE 9993/udp
