FROM ubuntu:latest
RUN apt-get update && \
    apt-get install -y curl
WORKDIR /app
COPY ip.sh .
RUN chmod +x ip.sh
RUN addgroup app && adduser --system --shell /bin/bash --ingroup app app
USER app
CMD ["/bin/bash","./ip.sh"]
