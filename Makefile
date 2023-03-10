READER_ROOT_DIR:=.

include common.mk

INSTALL_TOP:=/usr/local
INSTALL_INC:=$(INSTALL_TOP)/include/$(READER)
INSTALL_LIB:=$(INSTALL_TOP)/lib

.PHONY: all, static, shared, samples, exception_install, exception_uninstall, install_static, install_shared, install, uninstall, clean

# Any of the following make rules can be executed with the `-j` option (`make -j`) for parallel compilation 

all:
	cd $(READER_LIB_DIR) && $(MAKE) $@

static:
	cd $(READER_LIB_DIR) && $(MAKE) $@

shared:
	cd $(READER_LIB_DIR) && $(MAKE) $@

samples: static
	cd $(READER_BIN_DIR) && $(MAKE) all

exception_install:
	cd $(READER_DEPENDENCIES_DIR)/exception && $(MAKE) install

exception_uninstall:
	cd $(READER_DEPENDENCIES_DIR)/exception && $(MAKE) uninstall

install_static: exception_install
	mkdir -p $(INSTALL_INC) $(INSTALL_LIB)
	install -p -m 0644 $(READER_LIB_DIR)/*.hpp $(INSTALL_INC)
	install -p -m 0644 $(READER_LIB_DIR)/$(READER_STATIC_LIB) $(INSTALL_LIB)

install_shared: exception_install
	mkdir -p $(INSTALL_INC) $(INSTALL_LIB)
	install -p -m 0644 $(READER_LIB_DIR)/*.hpp $(INSTALL_INC)
	install -p -m 0644 $(READER_LIB_DIR)/$(READER_SHARED_LIB) $(INSTALL_LIB)

install: exception_install
	mkdir -p $(INSTALL_INC) $(INSTALL_LIB)
	install -p -m 0644 $(READER_LIB_DIR)/*.hpp $(INSTALL_INC)
	install -p -m 0644 $(READER_LIB_DIR)/$(READER_STATIC_LIB) $(READER_LIB_DIR)/$(READER_SHARED_LIB) $(INSTALL_LIB)

uninstall: exception_uninstall
	$(RM) -R $(INSTALL_INC)
	$(RM) $(INSTALL_LIB)/$(READER_STATIC_LIB) $(INSTALL_LIB)/$(READER_SHARED_LIB)

clean:
	cd $(READER_LIB_DIR) && $(MAKE) $@
	cd $(READER_BIN_DIR) && $(MAKE) $@
