FROM dart:stable AS build

# Define a build argument for qdrant_url
ARG QDRANT_URL

RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter \
    && /usr/local/flutter/bin/flutter --version

ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:$PATH"

RUN flutter channel stable \
    && flutter upgrade \
    && flutter config --enable-web

WORKDIR /app

COPY pubspec.yaml ./
RUN flutter pub get

COPY . .

# Create a .env file if QDRANT_URL is provided
RUN if [ -n "$QDRANT_URL" ]; then echo "qdrant_url=$QDRANT_URL" > ./assets/.env; fi

RUN flutter pub get

RUN flutter build web

FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf

COPY --from=build /app/build/web /usr/share/nginx/html

COPY --from=build /app/assets /usr/share/nginx/html/assets

EXPOSE 8000

CMD ["nginx", "-g", "daemon off;"]
