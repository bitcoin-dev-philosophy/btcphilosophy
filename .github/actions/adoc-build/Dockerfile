# asciidoctor image
FROM asciidoctor/docker-asciidoctor
RUN apk --update add imagemagick
RUN gem install --no-document barby:0.6.8

LABEL "version"="1.0"

# Setup entrypoint
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

