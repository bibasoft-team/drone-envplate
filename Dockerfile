FROM alpine:3.6

WORKDIR /ep

RUN apk --no-cache add curl bash
RUN curl -sLo /usr/local/bin/ep https://github.com/kreuzwerker/envplate/releases/download/v0.0.8/ep-linux && chmod +x /usr/local/bin/ep

COPY ./run.sh .
RUN chmod +x run.sh

ENTRYPOINT ["./run.sh"]
