# --- Builder stage ---
FROM ubuntu:22.04 AS builder

# Install build dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    cmake \
    git \
    libusb-1.0-0-dev \
    libudev-dev && \
    rm -rf /var/lib/apt/lists/*

# Copy and extract SDRplay API installer
COPY SDRplay_RSP_API*.run /tmp/
WORKDIR /tmp
RUN chmod +x SDRplay_RSP_API*.run && \
    ./SDRplay_RSP_API*.run --noexec --target /tmp/sdrapi && \
    mkdir -p /opt/sdrplay_api/include /opt/sdrplay_api/lib /opt/sdrplay_api/bin && \
    cp /tmp/sdrapi/inc/*.h /opt/sdrplay_api/include/ && \
    cp /tmp/sdrapi/arm64/libsdrplay_api.so* /opt/sdrplay_api/lib/ && \
    cp /tmp/sdrapi/arm64/sdrplay_apiService /opt/sdrplay_api/bin/ && \
    ln -sf /opt/sdrplay_api/lib/libsdrplay_api.so.3.15 /opt/sdrplay_api/lib/libmirsdrapi-rsp.so && \
    chmod +x /opt/sdrplay_api/bin/sdrplay_apiService

# Clone the original repo
WORKDIR /opt
RUN git clone https://github.com/SDRplay/RSPTCPServer.git rsp_tcp

# Replace CMakeLists.txt with your fixed version
COPY CMakeLists.txt /opt/rsp_tcp/CMakeLists.txt

# Build rsp_tcp
WORKDIR /opt/rsp_tcp/build
RUN cmake .. && make && make install && strip /usr/local/bin/rsp_tcp

# --- Runtime stage ---
FROM ubuntu:22.04

# Install runtime dependencies only
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libusb-1.0-0 \
    libudev1 && \
    rm -rf /var/lib/apt/lists/*

# Copy built binaries and SDRplay API libs from builder
COPY --from=builder /usr/local/bin/rsp_tcp /usr/local/bin/
COPY --from=builder /opt/sdrplay_api /opt/sdrplay_api

# Configure SDRplay library path
RUN echo "/opt/sdrplay_api/lib" > /etc/ld.so.conf.d/sdrplay.conf && ldconfig

# Create entrypoint script
RUN echo '#!/bin/bash\n\
/opt/sdrplay_api/bin/sdrplay_apiService &\n\
sleep 2\n\
exec rsp_tcp "$@"\n' > /usr/local/bin/start-rsp_tcp.sh && \
    chmod +x /usr/local/bin/start-rsp_tcp.sh

ENTRYPOINT ["/usr/local/bin/start-rsp_tcp.sh"]
