FROM node:23.6.1

COPY . /app
WORKDIR /app

RUN npm install
RUN npx cypress install

RUN ls -la /root \
  && chmod 777 /root \
  && apt-get update \
  && apt-get install --no-install-recommends -y \
    # Always install: Needed to run Cypress
    xvfb \
    libglib2.0-0 \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libgtk-3-0 \
    libgbm1 \
    libasound2 \
    # Needed to support the ps command, while not used by cypress directly it is used by some of our examples and the dependency is small (~1mb).
    procps \
    # Needed to support curl, similar to ps, it's not directly used by cypress but leaving it in the container is practically free.
    curl \
    # Always install: Needed for dashboard integration
    git \
    # Install ssh client to enable git cloning via ssh without falling back to CI's native git client.
    openssh-client\
    # Chrome and Edge require wget even after installation. We could do more work to dynamically remove it, but I doubt it's worth it.
    wget \
    # Needed to make https calls from the docker container
    openssl \
    ca-certificates \
    # Fast lossless compression algorithm - preferred by GitHub @actions/cache
    zstd \
    # build only dependencies: removed in onbuild step
    bzip2 \
    gnupg \
    dirmngr \
    # Needed by cypress installation 'unzip.js' script
    unzip

CMD npx cypress run




