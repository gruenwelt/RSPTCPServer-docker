# RSPTCPServer Docker Container

A Dockerized build and runtime environment for [SDRplay/RSPTCPServer](https://github.com/SDRplay/RSPTCPServer), including the SDRplay API installation.

This setup runs efficiently even on compact ARM64 single-board computers such as the Raspberry Pi, ensuring broader accessibility and ease of use for common DIY and SDR projects. Thanks to Docker-based isolation, it is also portable and can be deployed on a broad range of systems, including desktops and standard Linux servers.

---

## 📌 Version

**v1.0.0** — Initial release with Docker and CMake adaption  
**Tested on**: Orange Pi Zero 2W (4GB RAM) and Banana Pi W4 Zero (2GB RAM) + SDRplay RSP1A; and connected from client softwares SDR Receiver and SDR++ 2

---

## ✅ Features

- Supports SDRplay RSP1A and other compatible RSP models
- Works with `rtl_tcp`-compatible clients (e.g.,  SDR Receiver, SDR++ 2,)
- Lightweight Docker container — no systemd, no sudo, fully headless

---

## 📦 Requirements

- Linux-based host system
- Docker installed on the host
- SDRplay hardware (e.g., RSP1A)
- Client software (e.g., SDR++ 2, SDR Receiver)
- SDRplay API installer for Linux  
  👉 Downloaded from [SDRplay.com](https://www.sdrplay.com/downloads/)

---

## 🏗️ Build Instructions

1. Clone this repository:

   ```bash
   git clone https://github.com/gruenwelt/RSPTCPServer-docker
   cd RSPTCPServer-docker
   ```

2. Download the `SDRplay_RSP_API*.run` and place it in the root of this repo.

3. Build and run the container:

   ```bash
   docker compose up -d
   ```

---

## 🚀 Usage

Once running, you can connect to the server using any `rtl_tcp`-compatible client:

```text
rtl_tcp=192.168.x.x:2222
```

Replace `192.168.x.x` with the IP address of your Docker host.

---

## 📝 Notes

- The included `CMakeLists.txt` is a modified version tailored for Docker builds.
- The container automatically starts the `sdrplay_apiService` before launching `rsp_tcp`.
- Port `2222` must be open and mapped for clients to connect.
- Docker build skips the interactive menu in the `SDRplay_RSP_API*.run` file which also displays the licence terms of using that software. Please install the software once manually to read the licence as the build script auto-accepts it on your behalf.

---
