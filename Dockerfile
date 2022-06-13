FROM alpine
ARG DELAY
RUN apk update
RUN apk add --update curl
RUN apk add --update jq
RUN rm -rf /var/cache/apk/*
COPY datacollect.sh /home/datacollect.sh
RUN chmod 777 /home/datacollect.sh
RUN mkdir /etc/cron.d && touch /etc/cron.d/hello-cron
RUN echo "$DELAY sh /home/datacollect.sh" >  /etc/cron.d/hello-cron
RUN chmod 0644 /etc/cron.d/hello-cron
RUN crontab /etc/cron.d/hello-cron
RUN touch /var/log/cron.log
CMD crond -l 2 -f
