# --------------------------------------------------------------------
# Dependencies' version pinning.
# --------------------------------------------------------------------

# FIXME: Use erlang.mk patched for RabbitMQ, while waiting for PRs to be
# reviewed and merged.

ERLANG_MK_REPO := https://github.com/rabbitmq/erlang.mk.git
ERLANG_MK_COMMIT := rabbitmq-tmp

# FIXME: As of 2015-11-20, we depend on Ranch 1.2.1, but erlang.mk
# defaults to Ranch 1.1.0. All projects depending indirectly on Ranch
# needs to add "ranch" as a BUILD_DEPS. The list of projects needing
# this workaround are:
#     o  rabbitmq-web-stomp
dep_ranch_commit := 1.2.1

# --------------------------------------------------------------------
# Compiler flags.
# --------------------------------------------------------------------

# FIXME: We copy Erlang.mk default flags here: rabbitmq-build.mk is
# loaded as a plugin, so before those variables are defined. And because
# Erlang.mk uses '?=', the flags we set here override the default set.

WARNING_OPTS += +debug_info \
		+warn_export_vars \
		+warn_shadow_vars \
		+warn_obsolete_guard
ERLC_OPTS += -Werror $(WARNING_OPTS)
TEST_ERLC_OPTS += $(WARNING_OPTS)

# Push our compilation options to both the normal and test ERLC_OPTS.
ERLC_OPTS += $(RMQ_ERLC_OPTS)
TEST_ERLC_OPTS += $(RMQ_ERLC_OPTS)

# Enable JUnit reports in common_test.
CT_OPTS += -ct_hooks cth_surefire
