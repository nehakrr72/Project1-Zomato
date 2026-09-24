FROM node:16-slim AS builder
WORKDIR /app #set workdir inside the image as /app.
COPY package*.json ./ #copy package.json and package-lock.json(files sitting in root directory of build context) to the workdir inside the image.
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Production
FROM builder AS final
WORKDIR /app
COPY --from=builder /app/build ./build
COPY package*.json ./
RUN npm install --production
EXPOSE 3000
CMD ["npm", "start"]

#Build context = whatever folder you point docker build at, typically the . in docker build . — meaning "use the folder I'm currently sitting in, on whatever machine is running this command, as the source of files this build is allowed to COPY from."