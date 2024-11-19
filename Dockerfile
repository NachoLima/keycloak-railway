# Base image for Keycloak
FROM quay.io/keycloak/keycloak:26.0.4 AS builder

# Switch to root user for copying files and running build commands
USER root

# Copy your custom themes to the Keycloak themes directory
COPY themes /opt/keycloak/themes

# Copy your custom providers (extensions) to the Keycloak providers directory
#COPY providers /opt/keycloak/providers

# Build Keycloak with your customizations
RUN /opt/keycloak/bin/kc.sh build

# Use a fresh Keycloak runtime image
FROM quay.io/keycloak/keycloak:26.0.4

# Switch to root user for setup
USER root

# Copy the built Keycloak files from the builder stage
COPY --from=builder /opt/keycloak /opt/keycloak

# Revert to non-root user for security
USER 1000

# Set entrypoint and default command for Keycloak
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start", "--optimized"]
