# RSPTCPServer Dockerfile and modified CMakeLists.txt file
A Dockerfile that builds and installs the required SDRPlay API for RSPTCPServer and the RSPTCPServer and runs in a container.

> 🛠️ The server references to [SDRplay/RSPTCPServer](https://github.com/SDRplay/RSPTCPServer).  
> In this repository, the work was focused on **Dockerizing** the build for Linux which required making changes to CMakeLists.txt from the original repo.  
> ✅ Tested on Orange Pi Zero 2W with the SDRplay RSP1A device. Should be able to run on other arm64 single-board computers like Raspberry Pi or other linux computers.

---

## ✅ Features

- Compatible with SDRplay RSP1A, and other RSP models
- Works with `rtl_tcp`-based clients like:
  - SDR++ 2
  - SDR Receiver
- Clean Docker container: No systemd, no sudo — works headlessly

---

## 📦 Requirements

- A linux based system as host
- Docker installed on your host
- An SDRPlay hardware device such as RSP1A
- A Mac, PC or a mobile device installed with SDR software or app such as SDR++ 2 or SDR Receiver to remote
- SDRplay API installer for Linux:  
  👉 Download [here](https://www.sdrplay.com/downloads/)

---

## 🏗️ Build Instructions

1. Download the installer `SDRplay*.run`
2. Place it in the root of this repo
3. Build the Docker image:

```bash
docker build -t rsp_tcp_server .
```

---

## 🚀 Run the container

```bash
docker run -d \
  --name RSPTCPServer_container \
  --restart unless-stopped \
  --device /dev/bus/usb \
  -p 2222:2222 \
  RSPTCPServer \
  rsp_tcp -a 0.0.0.0 -p 2222
```

You can then connect to the server using:
rtl_tcp=192.168.x.x:2222
