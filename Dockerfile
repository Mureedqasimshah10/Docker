FROM ubuntu:latest
RUN apt-get update && \
    apt-get install -y curl
WORKDIR /app
COPY ip.sh .
RUN chmod +x ip.sh
CMD ["/bin/bash","./ip.sh"]
