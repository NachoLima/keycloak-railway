FROM quay.io/keycloak/keycloak:26.0.4 AS builder

# Arguments for Keycloak features
ARG KC_HEALTH_ENABLED KC_METRICS_ENABLED KC_FEATURES KC_DB KC_HTTP_ENABLED PROXY_ADDRESS_FORWARDING QUARKUS_TRANSACTION_MANAGER_ENABLE_RECOVERY KC_HOSTNAME KC_LOG_LEVEL KC_DB_POOL_MIN_SIZE

# Adding custom providers
COPY /providers/. /opt/keycloak/providers

# Adding a custom theme
COPY /themes/. /opt/keycloak/themes

# Build Keycloak
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:26.0.4

# Copying built files from the builder stage
COPY --from=builder /opt/keycloak/ /opt/keycloak/

EXPOSE 8080

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start", "--optimized", "--http-enabled=true", "--http-port=8080", "--import-realm", "--spi-admin-console-username=admin", "--spi-admin-console-password=admin"]
