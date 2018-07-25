FROM alpine:3.8

RUN apk add --no-cache curl python

RUN curl -o /usr/local/bin/kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/linux/amd64/kubectl \
    && chmod +x /usr/local/bin/kubectl

RUN curl -o /usr/local/bin/heptio-authenticator-aws https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/linux/amd64/heptio-authenticator-aws \
    && chmod +x /usr/local/bin/heptio-authenticator-aws

RUN curl https://bootstrap.pypa.io/get-pip.py | python \
    && pip install awscli

ENTRYPOINT ["kubectl"]
