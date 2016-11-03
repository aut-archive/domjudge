FROM daavar/domjudge

COPY conf/supervisord.conf /etc/supervisord.conf

RUN useradd -d /nonexistent -g nogroup -s /bin/false domjudge-run

COPY entrypoint /
