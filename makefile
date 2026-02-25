projects = chunk concordance ligate phase split_reference
BOOST_DIR = boost_1_78_0
HTSLIB_DIR = htslib-1.16
HTSLIB_STATIC_LIB = $(HTSLIB_DIR)/libhts.a
BOOST_DEPS_STAMP = $(BOOST_DIR)/stage/lib/.glimpse_boost_stage.stamp

.PHONY: all deps boost-deps htslib-deps $(projects)

all: deps $(projects)

deps: boost-deps htslib-deps

boost-deps: $(BOOST_DEPS_STAMP)

$(BOOST_DEPS_STAMP):
	cd $(BOOST_DIR) && \
	./bootstrap.sh --with-libraries=iostreams,program_options,serialization && \
	./b2 --with-iostreams --with-program_options --with-serialization stage && \
	touch stage/lib/.glimpse_boost_stage.stamp

htslib-deps: $(HTSLIB_STATIC_LIB)

$(HTSLIB_STATIC_LIB):
	cd $(HTSLIB_DIR) && \
	$(MAKE) lib-static

$(projects):
	$(MAKE) -C $@ $(COMPILATION_ENV)

clean:
	for dir in $(projects); do \
	$(MAKE) $@ -C $$dir; \
	done
