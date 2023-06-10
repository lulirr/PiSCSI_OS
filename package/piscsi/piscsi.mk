PISCSI_VERSION = 23.04.01
PISCSI_SOURCE = v$(PISCSI_VERSION).tar.gz
PISCSI_SITE = https://github.com/PiSCSI/piscsi/archive/refs/tags
PISCSI_LICENSE = BSD 3-Clause License
PISCSI_LICENSE_FILES = LICENSE
PISCSI_DEPENDENCIES = spdlog libpcap protobuf bridge-utils libev libevdev

#$(BUILD_DIR)/ ?

define PISCSI_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)/cpp CXXFLAGS+="-I$(@D)/cpp" CXXFLAGS+="-I$(BUILD_DIR)/spdlog-1.11.0/include/" CXXFLAGS+="-L$(TARGET_DIR)/usr/lib -L$(TARGET_DIR)/usr/include" CXXFLAGS+="-DCONNECT_TYPE_FULLSPEC"
endef

define PISCSI_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/cpp/bin/fullspec/*  $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
