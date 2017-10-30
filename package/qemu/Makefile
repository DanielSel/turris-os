#
# Copyright (C) 2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=qemu
PKG_VERSION:=2.10.1
PKG_RELEASE:=1
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=http://wiki.qemu-project.org/download/
PKG_SOURCE_MD5SUM:=0c4d98038480c5c19a95990eb8d04a51
PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=LICENSE tcg/LICENSE
PKG_MAINTAINER:=Yousong Zhou <yszhou4tech@gmail.com>

include $(INCLUDE_DIR)/package.mk

define Package/qemu
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=QEMU
  URL:=http://www.qemu.org
  DEPENDS:=+glib2 +libpthread +libstdcpp +librt
endef

define Package/qemu/description
  This package contains the QEMU
endef

# QEMU configure script does not recognize these options
CONFIGURE_ARGS:=$(filter-out	\
	--target=%		\
	--host=%		\
	--build=%		\
	--program-prefix=%	\
	--program-suffix=%	\
	--exec-prefix=%		\
	--disable-nls		\
	, $(CONFIGURE_ARGS))

# Building qemu-ga alone does not require zlib
CONFIGURE_ARGS+=			\
	--cross-prefix="$(TARGET_CROSS)"	\
	--host-cc="$(HOSTCC)"		\
	--target-list='x86_64-linux-user i386-linux-user'		\
	--disable-zlib-test		\
	--disable-guest-agent \
	--disable-sdl \
	--disable-gtk \
	--disable-vnc \
	--disable-spice \
	--without-pixman --disable-tools --disable-system

define Package/qemu/install
	$(MAKE) DESTDIR="$(1)" install
endef

$(eval $(call BuildPackage,qemu))
