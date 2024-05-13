FROM --platform=linux/amd64 alpine

RUN apk add --no-cache \
      chromium \
      nss \
      freetype \
      harfbuzz \
      ca-certificates \
      ttf-freefont

RUN apk add nodejs npm; \
    npm install -g pnpm

ENV COREPACK_ENABLE_STRICT=0
WORKDIR /usr/app
COPY . .
RUN pnpm install
RUN pnpm run build || true

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
ENV SITE="https://goreplay.org"
ENV OUTPUT_PATH="/files/goreplay"

RUN chown root:root /usr/lib/chromium/chrome-sandbox && \
    chmod 4755 /usr/lib/chromium/chrome-sandbox

# # Add user so we don't need --no-sandbox.
# RUN addgroup -S unlighthouse && adduser -S -G unlighthouse unlighthouse \
#     && mkdir -p /home/unlighthouse/Downloads /app \
#     && chown -R unlighthouse:unlighthouse /home/unlighthouse \
#     && chown -R unlighthouse:unlighthouse /app

# Run everything after as non-privileged user.
USER root
RUN mkdir files
CMD pnpm run ci --site ${SITE} --build-static --output-path ${OUTPUT_PATH}
