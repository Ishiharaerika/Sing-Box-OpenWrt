include $(TOPDIR)/rules.mk

PKG_NAME:=sing-box-alpha
PKG_VERSION:=1.10.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/Ishiharaerika/sing-box-alpha.git
PKG_SOURCE_VERSION:=6478c7e0294f0887e15261bf7a4439b385136b81
PKG_MIRROR_HASH:=skip
PKG_HASH:=skip

PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=IshiharaErika

# Hardcode configuration options
CONFIG_SINGBOX_WITH_ACME=y
CONFIG_SINGBOX_WITH_CLASH_API=y
CONFIG_SINGBOX_WITH_DHCP=y
CONFIG_SINGBOX_WITH_ECH=y
CONFIG_SINGBOX_WITH_EMBEDDED_TOR=n
CONFIG_SINGBOX_WITH_GRPC=y
CONFIG_SINGBOX_WITH_GVISOR=y
CONFIG_SINGBOX_WITH_QUIC=y
CONFIG_SINGBOX_WITH_REALITY_SERVER=y
CONFIG_SINGBOX_WITH_UTLS=y
CONFIG_SINGBOX_WITH_V2RAY_API=y
CONFIG_SINGBOX_WITH_WIREGUARD=y

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_BUILD_FLAGS:=no-mips16

GO_PKG:=github.com/Ishiharaerika/sing-box-alpha
GO_PKG_BUILD_PKG:=github.com/Ishiharaerika/sing-box-alpha/cmd/sing-box

GO_PKG_LDFLAGS_X:=github.com/Ishiharaerika/sing-box-alpha/constant

include /home/erika/openwrt/include/package.mk
include /home/erika/openwrt/feeds/packages/lang/golang/golang-package.mk

define Package/sing-box-alpha
  TITLE:=Just for test.
  CATEGORY:=Network
  URL:=https://sing-box.sagernet.org
  DEPENDS:=$(GO_ARCH_DEPENDS) +ca-bundle +kmod-inet-diag +kmod-tun
  USERID:=sing-box-alpha=5566:sing-box-alpha=5566
  ONLY_FOR_ARCH:=x86_64
endef

define Package/sing-box-alpha/description
  sing-box-alpha for test.
endef

define Package/sing-box-alpha/config
  menu "Select build options"
    depends on PACKAGE_sing-box-alpha

    config SINGBOX_WITH_ACME
      bool "Build with ACME TLS certificate issuer support"

    config SINGBOX_WITH_CLASH_API
      bool "Build with Clash API support"
      default y

    config SINGBOX_WITH_DHCP
      bool "Build with DHCP support, see DHCP DNS transport."

    config SINGBOX_WITH_ECH
      bool "Build with TLS ECH extension support for TLS outbound"
      default y

    config SINGBOX_WITH_EMBEDDED_TOR
      bool "Build with embedded Tor support"

    config SINGBOX_WITH_GRPC
      bool "Build with standard gRPC support"

    config SINGBOX_WITH_GVISOR
      bool "Build with gVisor support"
      default y

    config SINGBOX_WITH_QUIC
      bool "Build with QUIC support"
      default y

    config SINGBOX_WITH_REALITY_SERVER
      bool "Build with reality TLS server support, see TLS."
      default y

    config SINGBOX_WITH_UTLS
      bool "Build with uTLS support for TLS outbound"
      default y

    config SINGBOX_WITH_V2RAY_API
      bool "Build with V2Ray API support"

    config SINGBOX_WITH_WIREGUARD
      bool "Build with WireGuard support"
      default y
  endmenu
endef

PKG_CONFIG_DEPENDS:= \
  CONFIG_SINGBOX_WITH_ACME \
  CONFIG_SINGBOX_WITH_CLASH_API \
  CONFIG_SINGBOX_WITH_DHCP \
  CONFIG_SINGBOX_WITH_ECH \
  CONFIG_SINGBOX_WITH_EMBEDDED_TOR \
  CONFIG_SINGBOX_WITH_GRPC \
  CONFIG_SINGBOX_WITH_GVISOR \
  CONFIG_SINGBOX_WITH_QUIC \
  CONFIG_SINGBOX_WITH_REALITY_SERVER \
  CONFIG_SINGBOX_WITH_UTLS \
  CONFIG_SINGBOX_WITH_V2RAY_API \
  CONFIG_SINGBOX_WITH_WIREGUARD

GO_PKG_TAGS:=$(subst $(space),$(comma),$(strip \
  $(if $(CONFIG_SINGBOX_WITH_ACME),with_acme) \
  $(if $(CONFIG_SINGBOX_WITH_CLASH_API),with_clash_api) \
  $(if $(CONFIG_SINGBOX_WITH_DHCP),with_dhcp) \
  $(if $(CONFIG_SINGBOX_WITH_ECH),with_ech) \
  $(if $(CONFIG_SINGBOX_WITH_EMBEDDED_TOR),with_embedded_tor) \
  $(if $(CONFIG_SINGBOX_WITH_GRPC),with_grpc) \
  $(if $(CONFIG_SINGBOX_WITH_GVISOR),with_gvisor) \
  $(if $(CONFIG_SINGBOX_WITH_QUIC),with_quic) \
  $(if $(CONFIG_SINGBOX_WITH_REALITY_SERVER),with_reality_server) \
  $(if $(CONFIG_SINGBOX_WITH_UTLS),with_utls) \
  $(if $(CONFIG_SINGBOX_WITH_V2RAY_API),with_v2ray_api) \
  $(if $(CONFIG_SINGBOX_WITH_WIREGUARD),with_wireguard) \
))

define Package/sing-box-alpha/conffiles
/etc/config/sing-box-alpha
/etc/sing-box-alpha/
endef

define Package/sing-box-alpha/install
  $(INSTALL_DIR) $(1)/usr/bin/
  $(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/sing-box-alpha $(1)/usr/bin/sing-box-alpha

  $(INSTALL_DIR) $(1)/etc/sing-box-alpha
  $(INSTALL_DATA) $(PKG_BUILD_DIR)/release/config/config.json $(1)/etc/sing-box-alpha

  $(INSTALL_DIR) $(1)/etc/config/
  $(INSTALL_CONF) ./files/sing-box-alpha.conf $(1)/etc/config/sing-box-alpha
  $(INSTALL_DIR) $(1)/etc/init.d/
  $(INSTALL_BIN) ./files/sing-box-alpha.init $(1)/etc/init.d/sing-box-alpha
endef

$(eval $(call BuildPackage,sing-box-alpha))