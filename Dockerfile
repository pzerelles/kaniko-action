FROM alpine as tools

RUN apk --update add ca-certificates curl

RUN mkdir /kaniko && \
    curl -o /kaniko/jq -L https://github.com/stedolan/jq/releases/download/jq-1.7.1/jq-linux64 && \
    chmod +x /kaniko/jq && \
    curl -o /kaniko/reg -L https://github.com/genuinetools/reg/releases/download/v0.16.1/reg-linux-386 && \
    chmod +x /kaniko/reg && \
    curl -o /tmp/crane.tar.gz -L https://github.com/google/go-containerregistry/releases/download/v0.17.0/go-containerregistry_Linux_x86_64.tar.gz && \
    tar -C /kaniko -xvzf /tmp/crane.tar.gz crane && \
    rm /tmp/crane.tar.gz

FROM gcr.io/kaniko-project/executor:debug

COPY entrypoint.sh /
COPY --from=tools /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=tools /kaniko/ /kaniko/

ENTRYPOINT ["/entrypoint.sh"]

LABEL repository="https://github.com/aevea/action-kaniko" \
    maintainer="Alex Viscreanu <alexviscreanu@gmail.com>"
