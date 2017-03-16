# -----------------------------------------------------------------------------
# CMake project wrapper Makefile ----------------------------------------------
# -----------------------------------------------------------------------------

SHELL := /bin/bash
RM    := /bin/rm -rf
MKDIR := /bin/mkdir -p

BUILD_DIR := .build

all: ./$(BUILD_DIR)/Makefile
	@ $(MAKE) -C $(BUILD_DIR)

clean:
	@ $(MAKE) -C $(BUILD_DIR) clean

./$(BUILD_DIR)/Makefile:
	@ ($(MKDIR) $(BUILD_DIR) > /dev/null)
	@ (cd $(BUILD_DIR) > /dev/null 2>&1 && cmake ..)

distclean:
	$(RM) ./$(BUILD_DIR)
	$(RM) ./bin

watch:
	@ nodemon -w . -e 'cpp hpp' --exec "$(MAKE) -C $(BUILD_DIR)"

ifeq ($(findstring distclean,$(MAKECMDGOALS)),)
	$(MAKECMDGOALS): ./$(BUILD_DIR)/Makefile
	@ $(MAKE) -C $(BUILD_DIR) $(MAKECMDGOALS)
endif
