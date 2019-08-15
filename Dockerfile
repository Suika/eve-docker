FROM alpine:3.9
EXPOSE 3000
WORKDIR /eve
ENTRYPOINT [ "/eve/entrypoint.sh"]
ENV UID=${UID:-1000} GID=${GID:-1000}

COPY entrypoint.sh /eve/entrypoint.sh
RUN wget https://github.com/bibanon/eve/archive/master.tar.gz -qO- | tar xzf - --strip-components=1 -C /eve
RUN apk add --update --no-cache  python3 py3-mysqlclient shadow su-exec nodejs
RUN apk add --update --no-cache --virtual eve-build-dep gcc musl-dev python3-dev \
    && pip3 install -r requirements.txt \
    && apk del eve-build-dep \
    && addgroup -g 1000 eve \
    && adduser -h /eve -u 1000 -H -S -G eve eve \
    && chown eve:eve -R /eve \
    && python3 -m pip uninstall --yes setuptools pip \
    && find / | grep -E "(__pycache__|\.pyc|\.exe|\.pyo$)" | xargs rm -rf