# This Makefile is copied to and included by each RabbitMQ components.
# It serves two purposes:
#     1. Pull subsequent Makefiles
#     2. Handle and protect $(DEPS_DIR) when we are under the umbrella.
#
# This file must be included *BEFORE* erlang.mk.
#
# The original copy is available from:
#   https://github.com/rabbitmq/rabbitmq_mk

ifeq ($(.DEFAULT_GOAL),)
# Define default goal to `all` because this file defines some targets
# before the inclusion of erlang.mk leading to the wrong target becoming
# the default.
.DEFAULT_GOAL = all
endif

# Pull the next Makefile in. In particular, this Makefile declares all
# the RabbitMQ components. With this loaded, it's easy for any project
# to depend on any of those components.

dep_rabbitmq_mk ?= git https://github.com/rabbitmq/rabbitmq-mk master
BUILD_DEPS += rabbitmq_mk
DEP_PLUGINS += rabbitmq_mk/rabbitmq-components.mk

# If this project is under the Umbrella project, we override $(DEPS_DIR)
# to point to the Umbrella's one. We also disable `make distclean` so
# $(DEPS_DIR) is not accidentally removed.

ifneq ($(wildcard ../../UMBRELLA.md),)
UNDER_UMBRELLA := 1
else ifneq ($(wildcard UMBRELLA.md),)
UNDER_UMBRELLA := 1
endif

ifeq ($(UNDER_UMBRELLA),1)
ifneq ($(PROJECT),rabbitmq_public_umbrella)
DEPS_DIR ?= $(abspath ..)

distclean:: distclean-components
	@:

distclean-components:
endif

ifneq ($(filter distclean distclean-deps,$(MAKECMDGOALS)),)
SKIP_DEPS = 1
endif
endif
