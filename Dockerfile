# Instalar node y etapa de dependencias
FROM node:19.2-alpine3.16 as dependencies
# cd app
WORKDIR /app
# Copiamos el package.json en el WORKDIR
COPY package.json ./
# Instalar todas las dependencia
RUN npm install



# Instalar node y etapa de dependencias de producció
FROM node:19.2-alpine3.16 as prod-dependencies
# cd app
WORKDIR /app
# Copiamos el package.json en el WORKDIR
COPY package.json ./
# Instalar todas las dependencia
RUN npm install --prod



# Instalar node y etapa de build
FROM node:19.2-alpine3.16 as builder
# cd app
WORKDIR /app
# Copiar el dependencies en /app/node_modules
COPY --from=dependencies /app/node_modules ./node_modules
# Copiamos todo el proyecto segun el dockerignore
COPY . .
# Realizamos pruebas unitarias
RUN npm run test



FROM node:19.2-alpine3.16 as runner
# cd app
WORKDIR /app
# Copiar el dependencies en /app/node_modules
COPY --from=prod-dependencies /app/node_modules ./node_modules
# Copiamos app.js
COPY app.js ./
# Copiamos el directorio tasks
COPY tasks/ ./tasks
# comando run de la imagen
CMD ["node", "app.js"]