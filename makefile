projects = chunk concordance ligate phase split_reference
BOOST_DIR = boost_1_78_0
HTSLIB_DIR = htslib-1.16
HTSLIB_STATIC_LIB = $(HTSLIB_DIR)/libhts.a
BOOST_DEPS_STAMP = $(BOOST_DIR)/stage/lib/.glimpse_boost_stage.stamp
TOP_BIN_DIR = bin
PROJECT_BINS = \
	chunk/bin/GLIMPSE2_chunk \
	concordance/bin/GLIMPSE2_concordance \
	ligate/bin/GLIMPSE2_ligate \
	phase/bin/GLIMPSE2_phase \
	split_reference/bin/GLIMPSE2_split_reference

.PHONY: all deps boost-deps htslib-deps collect-binaries clean $(projects)

all: deps $(projects) collect-binaries

deps: boost-deps htslib-deps

boost-deps: $(BOOST_DEPS_STAMP)

$(BOOST_DEPS_STAMP):
	cd $(BOOST_DIR) && \
	./bootstrap.sh --with-libraries=iostreams,program_options,serialization && \
	./b2 --with-iostreams --with-program_options --with-serialization cxxflags='-Wno-uninitialized' stage && \
	touch stage/lib/.glimpse_boost_stage.stamp

htslib-deps: $(HTSLIB_STATIC_LIB)

$(HTSLIB_STATIC_LIB):
	cd $(HTSLIB_DIR) && \
	$(MAKE) lib-static CFLAGS='-g -Wall -O2 -fvisibility=hidden -Wno-deprecated-declarations'

$(projects):
	$(MAKE) -C $@ $(COMPILATION_ENV)

collect-binaries: $(PROJECT_BINS)
	mkdir -p $(TOP_BIN_DIR)
	cp -f $(PROJECT_BINS) $(TOP_BIN_DIR)/

clean:
	for dir in $(projects); do \
	$(MAKE) $@ -C $$dir; \
	done
	-cd $(BOOST_DIR) && ./b2 --clean-all
	-rm -rf $(BOOST_DIR)/stage $(BOOST_DIR)/bin.v2
	-rm -f $(BOOST_DEPS_STAMP)
	-$(MAKE) -C $(HTSLIB_DIR) clean
	-rm -f $(TOP_BIN_DIR)/GLIMPSE2_*
