FROM alpine:3.18

RUN apk add --no-cache bash curl jq

COPY rootfs/ /
COPY run.sh /run.sh
RUN chmod +x /run.sh /etc/services.d/organizer/run /etc/services.d/organizer/finish

CMD ["/run.sh"]
