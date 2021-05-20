FROM php:7.2-alpine
# MAINTAINER RouRouX <itrourou@gmail.com>

ENV CRON="00 09 * * *"

RUN apk add git tzdata && \
	git clone --depth 1 https://github.com/acmesh-official/acme.sh.git && \
	git clone --depth 1 https://github.com/luolongfei/freenom.git && \
	cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
	apk del tzdata git && \
	mkdir -p /confbak/ && \
	cp /freenom/.env.example /confbak/.env && \
	cp /freenom/config.php /confbak/ && \
	cp /freenom/.env.example /freenom/.env && \
	cp /freenom/run /freenom/run.php

COPY acme.php start.sh /freenom/
RUN chmod +x /freenom/start.sh

# VOLUME ["/conf"]
CMD ["/freenom/start.sh"]