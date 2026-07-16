# libcamera-v4l2bridge
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor-GitHub%20Sponsors-blue?logo=github)](https://github.com/sponsors/kevinveenbirkenbach) [![Patreon](https://img.shields.io/badge/Support-Patreon-orange?logo=patreon)](https://www.patreon.com/c/kevinveenbirkenbach) [![Buy Me a Coffee](https://img.shields.io/badge/Buy%20me%20a%20Coffee-Funding-yellow?logo=buymeacoffee)](https://buymeacoffee.com/kevinveenbirkenbach) [![PayPal](https://img.shields.io/badge/Donate-PayPal-blue?logo=paypal)](https://s.veen.world/paypaldonate)


**Short Description:**  
A lightweight setup for bridging Intel IPU6 cameras from **libcamera** to a **virtual V4L2 device** using `v4l2loopback`, enabling compatibility with applications such as **Chromium**, **Zoom**, **OBS**, and **Cheese**.

---

## 🧭 Overview

Many modern laptops — including the **HP Spectre x360 14** — use **Intel IPU6** camera hardware that is supported only through the **libcamera** stack on Linux.  
However, most desktop applications still expect a traditional **V4L2** webcam device (e.g., `/dev/video*`).  

This project provides a documented approach to bridge these two worlds by:
- Loading the `v4l2loopback` kernel module to create a virtual camera device (`/dev/video32`)
- Streaming video frames from **libcamera** into that device using **GStreamer**
- Managing everything with **systemd user units**, **sudoers rules**, and **desktop launchers**

---

## ⚙️ Installation

```bash
make install
````

If you are not root, install the sudoers rule manually:

```bash
sudo install -m 440 files/sudoers/99-libcamera-bridge /etc/sudoers.d/
```

Then reload your user services:

```bash
systemctl --user daemon-reload
```

---

## 🚀 Usage

Start the bridge manually:

```bash
~/.local/bin/libcamera-bridge-start
```

Stop it:

```bash
~/.local/bin/libcamera-bridge-stop
```

Once active, the new camera device will appear as:

```
/dev/video32 → Libcamera Bridge
```

Applications like **Chromium**, **OBS**, or **Zoom** can then access it as a standard webcam.

---

## 🔁 Autostart Integration

Enable automatic startup:

```bash
make enable
```

Disable it again:

```bash
make disable
```

Desktop launchers `Start Libcamera Bridge` and `Stop Libcamera Bridge`
will appear under **Applications → Video**.

---

## 🧩 Components Installed

| Path                                                         | Purpose                                       |
| ------------------------------------------------------------ | --------------------------------------------- |
| `~/.local/bin/libcamera-bridge-start`                        | Starts the libcamera → V4L2 pipeline          |
| `~/.local/bin/libcamera-bridge-stop`                         | Stops the bridge and turns off the camera LED |
| `~/.config/systemd/user/libcamera-v4l2bridge.service`        | Manages the GStreamer pipeline                |
| `/etc/sudoers.d/99-libcamera-bridge`                         | Allows modprobe without a password            |
| `~/.local/share/applications/libcamera-v4l2bridge-*.desktop` | GUI entries for start/stop actions            |

---

## 🧠 Troubleshooting

If the service fails or the camera LED remains active after boot:

1. Stop the service:

   ```bash
   systemctl --user stop libcamera-v4l2bridge.service
   ```
2. Unload the module manually:

   ```bash
   sudo modprobe -r v4l2loopback
   ```
3. Verify devices:

   ```bash
   v4l2-ctl --list-devices
   ```

If you receive “Operation not permitted” messages, ensure your sudoers file exists:

```
/etc/sudoers.d/99-libcamera-bridge
```

and contains:

```
kevinveenbirkenbach ALL=(ALL) NOPASSWD: /usr/bin/modprobe v4l2loopback, /usr/bin/modprobe -r v4l2loopback
```

---

## 🧾 Reference

This setup and documentation were created during an in-depth troubleshooting session
with [**ChatGPT (GPT-5)** on **October 18, 2025**](https://chatgpt.com/share/68f4023c-f4bc-800f-bcb5-b4eda42967e9), addressing IPU6 camera driver and
libcamera-to-V4L2 bridging issues on **Manjaro Linux** for the **HP Spectre x360 14**.

The session included:

* IPU6 driver compilation and DKMS setup
* libcamera pipeline testing with GStreamer
* v4l2loopback integration via systemd and sudoers
* Desktop launchers and LED behavior tuning

---

## ⚠️ Disclaimer

This repository is intended **for documentation and educational purposes only**.
It serves as a reproducible reference for configuring **libcamera–v4l2 bridging** on Linux systems.

It is **not a functional program or production-ready package**.
No executables, binaries, or compiled code are distributed as part of this repository.

---

## 📜 Author
Kevin Veen-Birkenbach
🌐 [https://www.veen.world/](https://www.veen.world/)
