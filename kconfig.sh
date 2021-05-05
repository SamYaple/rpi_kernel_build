#!/bin/bash

set -eu

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NOCOLOR='\033[0m'

set_enable() {
	echo -en "${GREEN}"
	for option in "${ENABLE_OPTS[@]}"; do
		echo -e "${option}"
		./scripts/config --enable "${option}"
	done
	echo -en "${NOCOLOR}"
}

set_disable() {
	echo -en "${RED}"
	for option in "${DISABLE_OPTS[@]}"; do
		echo -e "${option}"
		./scripts/config --disable "${option}"
	done
	echo -en "${NOCOLOR}"
}

set_string() {
	echo -en "${PURPLE}"
	for option in "${STR_OPTS[@]}"; do
		echo -e "${option}"
		./scripts/config --set-str "${option%%=*}" "${option#*=}"
	done
	echo -en "${NOCOLOR}"
}

set_value() {
	echo -en "${YELLOW}"
	for option in "${VAL_OPTS[@]}"; do
		echo -e "${option}"
		./scripts/config --set-val "${option%%=*}" "${option#*=}"
	done
	echo -en "${NOCOLOR}"
}

set_module() {
	echo -en "${BLUE}"
	for option in "${MODULE_OPTS[@]}"; do
		echo -e "${option}"
		./scripts/config --module "${option}"
	done
	echo -en "${NOCOLOR}"
}

ENABLE_OPTS=(
	# main configuration
	MODULES
	IKCONFIG
	IKCONFIG_PROC	# make .config available at /proc/config.gz
	IKHEADERS	# make headers available at /sys/kernel/kheaders.tar.xz
	PARTITION_ADVANCED
	EFI_PARTITION
	CC_OPTIMIZE_FOR_PERFORMANCE	# Sets -O2 optimizations
	#CC_OPTIMIZE_FOR_SIZE		# Sets -Os optimizations
	SLUB
	NET
	NETDEVICES
	#SECURITY
	#SECURITY_APPARMOR
	#SECURITY_SELINUX
	UNIX
	INET
	IPV6
	BRIDGE
	VLAN_8021Q


	# systemd requirements
	TMPFS
	TMPFS_XATTR


	# rpi4 main configuration, each section can be enabled independently
	STAGING	# needed for some drivers below as of kernel 5.11.16
	ARCH_BCM2835
	CLK_BCM2711_DVP
	CLK_RASPBERRYPI
	RASPBERRYPI_FIRMWARE
	RASPBERRYPI_POWER
	RESET_RASPBERRYPI
	MAILBOX
	BCM2835_MBOX

	# rpi dma support
	DMADEVICES
	DMA_BCM2835

	# rpi cpu freq controller
	CPU_FREQ
	ARM_RASPBERRYPI_CPUFREQ

	# rpi sensors
	MFD_SYSCON
	HWMON
	SENSORS_RASPBERRYPI_HWMON
	THERMAL
	BCM2711_THERMAL
	BCM2835_THERMAL

	## rpi hardware RNG
	HW_RANDOM
	HW_RANDOM_BCM2835

	## rpi watchdog
	WATCHDOG
	BCM2835_WDT

	## rpi pwm poe fan
	PWM
	PWM_BCM2835

	## rpi serial
	#SPI
	#SPI_BCM2835
	#SPI_BCM2835AUX
	#SERIAL_8250
	#SERIAL_8250_BCM2835AUX
	#SERIAL_8250_EXTENDED
	#SERIAL_8250_SHARE_IRQ

	## rpi ethernet
	NET_VENDOR_BROADCOM
	BCMGENET

	## rpi wlan
	WLAN
	WLAN_VENDOR_BROADCOM
	CFG80211
	BRCMFMAC

	## rpi bluetooth
	RFKILL
	BT

	## rpi camera
	#MEDIA_SUPPORT
	#VIDEO_V4L2
	#VIDEO_BCM2835

	## rpi misc
	#GPIO_RASPBERRYPI_EXP	# gpio expander

	## rpi sd card
	MMC
	MMC_BCM2835

	## rpi i2c
	I2C
	I2C_BCM2835

	## rpi video and sound (video depends on sound)
	BCM_VIDEOCORE
	SOUND
	SND
	SND_SOC
	SND_BCM2835
	SND_BCM2835_SOC_I2S
	DRM
	DRM_VC4
	DRM_VC4_HDMI_CEC

	## rpi touchscreen (depends on video and i2c)
	#INPUT_TOUCHSCREEN
	#BACKLIGHT_CLASS_DEVICE
	#TOUCHSCREEN_RASPBERRYPI_FW
	#DRM_PANEL_RASPBERRYPI_TOUCHSCREEN
	#REGULATOR
	#REGULATOR_RASPBERRYPI_TOUCHSCREEN_ATTINY
)

STR_OPTS=(
	# systemd requirements
	#UEVENT_HELPER_PATH=""
)

VAL_OPTS=(
	NR_CPUS=4	# rpi4 only has 4 cpus
)

MODULE_OPTS=(
)

DISABLE_OPTS=(
	EXPERT
	EMBEDDED
	#MODULES
	#CC_OPTIMIZE_FOR_PERFORMANCE	# Sets -O2 optimizations
	CC_OPTIMIZE_FOR_SIZE		# Sets -Os optimizations
	SLOB

	# systemd requirements
	SYSFS_DEPRECATED	
	FW_LOADER_USER_HELPER
	LEDS_LP55XX_COMMON	# This selects FW_LOADER_USER_HELPER

	#rpi4
	CONFIG_CRYPTO_AEGIS128_SIMD	# rpi4 fails to compile w/ tuned KFLAGS
	MEDIA_SUPPORT_FILTER		# needed for DRM_VC4

	# unused drivers
	NET_VENDOR_ALACRITECH
	NET_VENDOR_AMAZON
	NET_VENDOR_AMD
	NET_VENDOR_AQUANTIA
	NET_VENDOR_ARC
	NET_VENDOR_AURORA
	NET_VENDOR_CADENCE
	NET_VENDOR_CAVIUM
	NET_VENDOR_CORTINA
	NET_VENDOR_EZCHIP
	NET_VENDOR_GOOGLE
	NET_VENDOR_HISILICON
	NET_VENDOR_HUAWEI
	NET_VENDOR_INTEL
	NET_VENDOR_MARVELL
	NET_VENDOR_MELLANOX
	NET_VENDOR_MICREL
	NET_VENDOR_MICROCHIP
	NET_VENDOR_MICROSEMI
	NET_VENDOR_NATSEMI
	NET_VENDOR_NETRONOME
	NET_VENDOR_NI
	NET_VENDOR_PENSANDO
	NET_VENDOR_QUALCOMM
	NET_VENDOR_RENESAS
	NET_VENDOR_ROCKER
	NET_VENDOR_SAMSUNG
	NET_VENDOR_SEEQ
	NET_VENDOR_SMSC
	NET_VENDOR_SOCIONEXT
	NET_VENDOR_SOLARFLARE
	NET_VENDOR_STMICRO
	NET_VENDOR_SYNOPSYS
	NET_VENDOR_VIA
	NET_VENDOR_WIZNET
	NET_VENDOR_XILINX
	WLAN_VENDOR_ADMTEK
	WLAN_VENDOR_ATH
	WLAN_VENDOR_ATMEL
	WLAN_VENDOR_CISCO
	WLAN_VENDOR_INTEL
	WLAN_VENDOR_INTERSIL
	WLAN_VENDOR_MARVELL
	WLAN_VENDOR_MEDIATEK
	WLAN_VENDOR_MICROCHIP
	WLAN_VENDOR_QUANTENNA
	WLAN_VENDOR_RALINK
	WLAN_VENDOR_REALTEK
	WLAN_VENDOR_RSI
	WLAN_VENDOR_ST
	WLAN_VENDOR_TI
	WLAN_VENDOR_ZYDAS
)


set_enable
set_module
set_string
set_value
set_disable
