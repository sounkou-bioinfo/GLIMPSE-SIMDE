FROM ubuntu:20.04

LABEL org.opencontainers.image.created="2022-11-30"
LABEL org.opencontainers.image.url="https://github.com/odelaneau/GLIMPSE"
LABEL org.opencontainers.image.version="2.0.0"
LABEL org.opencontainers.image.licences="MIT"
LABEL org.opencontainers.image.title="glimpse"
LABEL org.opencontainers.image.authors="simone.rubinacci@unil.ch"

WORKDIR /docker_build/

# Install required packages
RUN apt-get update && apt-get install -y build-essential libbz2-dev libcurl4-openssl-dev libssl-dev zlib1g-dev liblzma-dev libdeflate-dev

# Have to copy each subdirectory individually because the COPY command copies the contents, not the directories
COPY chunk GLIMPSE/chunk/
COPY common GLIMPSE/common/
COPY concordance GLIMPSE/concordance/
COPY ligate GLIMPSE/ligate/
COPY phase GLIMPSE/phase/
COPY split_reference GLIMPSE/split_reference/
COPY boost_1_78_0 GLIMPSE/boost_1_78_0/
COPY htslib-1.16 GLIMPSE/htslib-1.16/
COPY versions GLIMPSE/versions/
COPY makefile GLIMPSE/makefile

# Build GLIMPSE (deps are handled by root makefile)
RUN cd GLIMPSE && \
make clean && \
make -f makefile

RUN mv GLIMPSE/chunk/bin/GLIMPSE2_chunk GLIMPSE/split_reference/bin/GLIMPSE2_split_reference GLIMPSE/phase/bin/GLIMPSE2_phase GLIMPSE/ligate/bin/GLIMPSE2_ligate GLIMPSE/concordance/bin/GLIMPSE2_concordance /bin && \
chmod +x /bin/GLIMPSE2* && \
rm -rf GLIMPSE

WORKDIR /
