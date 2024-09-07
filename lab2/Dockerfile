FROM alpine:latest

# Copy program source code and entypoint script into image
COPY src /usr/src/signal-handler

# Instal build utils
RUN apk add --no-cache --virtual .build-deps \
    alpine-sdk  \
    # Install base utils
    && apk add --no-cache \
    bash \
    # Build application
    && gcc -o /usr/bin/signal-handler /usr/src/signal-handler/*.c \
    # Cleanup after build (delete French localization and build tools)
    && rm -fr /usr/src/signal-handler \
    && apk del --no-network .build-deps \
    && if [ -n "$tempDir" ]; then rm -fr "$tempDir"; fi \
    && if [ -f "/etc/apk/keys/abuild-key.rsa.pub" ]; then rm -f /etc/apk/keys/abuild-key.rsa.pub; fi

ENTRYPOINT [ "/usr/bin/signal-handler" ]

