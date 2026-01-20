# Hardware Setup Guide

## 1. Kernel Modules

### 1.1 nct6775 - Hardware Monitoring

**Motherboard:** ASUS ROG Strix Gaming X870E-E

**Problem:** CoolerControl was unable to detect or control motherboard fans.

**Solution:** Load the `nct6775` kernel module.

#### Why it works

The ASUS ROG Strix X870E-E motherboard uses a Nuvoton Super I/O chip (likely NCT6798D or similar) for hardware monitoring and fan control. This chip handles:

- Fan speed monitoring and PWM control
- Temperature sensor readings
- Voltage monitoring

By default, Linux may not load the `nct6775` driver automatically because:

1. The chip is accessed via ISA/LPC bus, not PCI, so there's no automatic device enumeration
2. Super I/O chips require probing specific I/O ports, which isn't done by default for safety reasons
3. ACPI may claim ownership of these resources, preventing automatic driver binding

Once the `nct6775` module is loaded, it exposes fan control interfaces via hwmon in `/sys/class/hwmon/`. CoolerControl can then detect these interfaces and provide fan curve management.

#### Setup

**Load module temporarily:**

```bash
sudo modprobe nct6775
```

**Load module permanently at boot:**

Create a configuration file in `/etc/modules-load.d/`:

```bash
echo "nct6775" | sudo tee /etc/modules-load.d/nct6775.conf
```

**Verify module is loaded:**

```bash
lsmod | grep nct6775
```

**Check sensor readings:**

```bash
# Install lm_sensors if not already installed
pacman -S lm_sensors

# Detect sensors
sudo sensors-detect

# View sensor data
sensors
```

**Supported chips:**

- NCT6102D/NCT6106D
- NCT6775F/NCT6776F
- NCT6779D/NCT6791D/NCT6792D/NCT6793D/NCT6795D/NCT6796D/NCT6797D/NCT6798D
- And other Nuvoton Super I/O chips

## 2. Fan Control

### 2.1 CoolerControl

CoolerControl is a GUI application for managing fan curves on Linux.

**Install:**

```bash
pacman -S coolercontrol
```

**Enable and start the service:**

```bash
sudo systemctl enable --now coolercontrold
```

**Note:** CoolerControl requires the appropriate kernel modules (like `nct6775`) to be loaded to detect motherboard fan headers. Without the module, only CPU cooler (via AMD or Intel drivers) may be visible.
