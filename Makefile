.DEFAULT_GOAL=help
.PHONY: run build clean help
DIR := $(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
STONESOUP := $(DIR)/stonesoup
CFLAGS := -fno-stack-protector
CPPFLAGS := -DSTONESOUP_TRACE=1 -I$(STONESOUP)/dependencies/include -D_GNU_SOURCE -I$(STONESOUP)/dependencies/include/libxml2 -I/opt/stonesoup/dependencies/include
LDFLAGS := -L$(STONESOUP)/dependencies/lib -L$(STONESOUP)/dependencies/lib64 -Wl,-R$(STONESOUP)/workspace/install/lib -Wl,-R$(STONESOUP)/workspace/install/lib64 -Wl,-R$(STONESOUP)/dependencies/lib -Wl,-R$(STONESOUP)/dependencies/lib64 -Wl,-z,execstack
LIBS := -ldl
TARGET = install/bin/tree


run: $(TARGET) ## Run the test case

build: $(TARGET) ## Build the test case

$(TARGET): .installed
	$(MAKE) -C src CFLAGS="$(CFLAGS)" CPPFLAGS="$(CPPFLAGS)" LDFLAGS="$(LDFLAGS)" LIBS="$(LIBS)"
	$(MAKE) -C src install prefix="$(DIR)/install"

clean: ## Clean the test case
	$(MAKE) -C src clean
	rm -r install

.installed: ## Install the dependencies
	sh install-dependencies.sh

help: ## Show this help
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
