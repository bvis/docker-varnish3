FROM centos:6

MAINTAINER Basilio Vera <basilio.vera@softonic.com>

ENV "VARNISH_VERSION=3.0.6" \
    "VCL_CONFIG=/etc/varnish/default.vcl" \
    "CACHE_SIZE=64m" \
    "VARNISHD_PARAMS=-p default_ttl=3600 -p default_grace=3600"

ADD rootfs /

RUN yum install -y \
    varnish-${VARNISH_VERSION} \
    /varnish-vmod-header-0.3-0.6.git20150319.softonic6.x86_64.rpm

EXPOSE 80

CMD ["/start.sh"]
