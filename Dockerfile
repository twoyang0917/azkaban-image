FROM openjdk:8-alpine

RUN apk add --no-cache tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata

ADD azkaban-web-server-3.74.3.zip

RUN unzip azkaban-web-server-3.74.3.zip -d /opt/ \
    && ln -s /opt/azkaban-web-server-3.74.3 /opt/azkaban-web-server \
    && rm -f azkaban-web-server-3.74.3.zip

ADD entrypoint.sh /opt/azkaban-web-server/
ENV AZKABAN_OPT="-Xms1G -Xmx1G"
EXPOSE 8081
WORKDIR /opt/azkaban-web-server
ENTRYPOINT ["sh", "/opt/azkaban-web-server/entrypoint.sh"]
