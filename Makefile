PREFIX        ?= $(HOME)
BIN_DIR       := $(PREFIX)/.local/bin
SYSTEMD_DIR   := $(PREFIX)/.config/systemd/user
DESKTOP_DIR   := $(PREFIX)/.local/share/applications
SUDOERS_DIR   := /etc/sudoers.d

.PHONY: all install uninstall enable disable

all:
	@echo "Available targets:"
	@echo "  make install   - Install all bridge components"
	@echo "  make uninstall - Remove all components"
	@echo "  make enable    - Enable autostart"
	@echo "  make disable   - Disable autostart"

install:
	@echo "Installing Libcamera → V4L2 Bridge…"
	mkdir -p $(BIN_DIR) $(SYSTEMD_DIR) $(DESKTOP_DIR)
	install -m 755 files/bin/libcamera-bridge-start $(BIN_DIR)/
	install -m 755 files/bin/libcamera-bridge-stop $(BIN_DIR)/
	install -m 644 files/systemd/libcamera-v4l2bridge.service $(SYSTEMD_DIR)/
	install -m 755 files/desktop/libcamera-v4l2bridge-start.desktop $(DESKTOP_DIR)/
	install -m 755 files/desktop/libcamera-v4l2bridge-stop.desktop $(DESKTOP_DIR)/
	@if [ "$$(id -u)" = "0" ]; then \
		echo "Installing sudoers rule…"; \
		install -m 440 files/sudoers/99-libcamera-bridge $(SUDOERS_DIR)/; \
	else \
		echo "NOTE: To install sudoers rule, run:"; \
		echo "  sudo install -m 440 files/sudoers/99-libcamera-bridge $(SUDOERS_DIR)/"; \
	fi
	systemctl --user daemon-reload

uninstall:
	@echo "Removing bridge components…"
	rm -f $(BIN_DIR)/libcamera-bridge-start
	rm -f $(BIN_DIR)/libcamera-bridge-stop
	rm -f $(SYSTEMD_DIR)/libcamera-v4l2bridge.service
	rm -f $(DESKTOP_DIR)/libcamera-v4l2bridge-start.desktop
	rm -f $(DESKTOP_DIR)/libcamera-v4l2bridge-stop.desktop
	@if [ "$$(id -u)" = "0" ]; then rm -f $(SUDOERS_DIR)/99-libcamera-bridge; fi
	systemctl --user daemon-reload || true

enable:
	systemctl --user enable libcamera-v4l2bridge.service

disable:
	systemctl --user disable libcamera-v4l2bridge.service
