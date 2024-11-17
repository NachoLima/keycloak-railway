FROM quay.io/keycloak/keycloak:26.0.4 AS builder
COPY /themes/. /opt/keycloak/themes
COPY /providers/. /opt/keycloak/providers
RUN /opt/keycloak/bin/kc.sh build
FROM quay.io/keycloak/keycloak:26.0.4

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]

CMD ["start", "--optimized", "--import-realm"]
