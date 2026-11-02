FROM public.ecr.aws/docker/library/node:latest
WORKDIR /

# clone server files (excluding cluster directory)
COPY public/ ./public/
COPY .cert/ ./.cert/
COPY src/ ./src/
COPY client.js ./
COPY server.js ./
COPY config.json ./

CMD ["node", "server.js"]