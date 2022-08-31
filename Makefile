VERSION = 21.02.3

URL = https://downloads.openwrt.org/releases/$(VERSION)/targets/mvebu/cortexa53/openwrt-imagebuilder-$(VERSION)-mvebu-cortexa53.Linux-x86_64.tar.xz
DOWNLOAD = openwrt-imagebuilder-$(VERSION)-mvebu-cortexa53.Linux-x86_64.tar.xz

DIR = openwrt-imagebuilder-${VERSION}-mvebu-cortexa53.Linux-x86_64

PACKAGES=" \
	luci luci-app-sqm luci-app-adblock \
	-dnsmasq -odhcpd-ipv6only dnsmasq-full stubby haveged bind-dig avahi-nodbus-daemon \
	tinc tcpdump ca-certificates ca-bundle iperf3 mtr emailrelay nmap adblock \
	usbutils usb-modeswitch kmod-usb-net-huawei-cdc-ncm kmod-usb-net-cdc-ether"


all: build-ext4-sdcard.img.gz

$(DOWNLOAD):
	wget -O $@.tmp $(URL)
	mv $@.tmp $(DOWNLOAD)

$(DIR)/Makefile: $(DOWNLOAD)
	tar xf $<
	touch $@

build-ext4-sdcard.img.gz: Makefile $(DIR)/Makefile
	$(MAKE) -C $(DIR) image \
		CONFIG_TARGET_ROOTFS_PARTSIZE=256 \
		PROFILE=globalscale_espressobin \
		PACKAGES=$(PACKAGES)
	cp ${DIR}/bin/targets/mvebu/cortexa53/openwrt-${VERSION}-mvebu-cortexa53-globalscale_espressobin-ext4-sdcard.img.gz $@
