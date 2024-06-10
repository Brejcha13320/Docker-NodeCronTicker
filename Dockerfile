# /app /usr /lib
FROM --platform=$BUILDPLATFORM node:19.2-alpine3.16

# cd app
WORKDIR /app

# dest /app
COPY . .

# instalar las dependencia
RUN npm install

# realizar testing
RUN npm run test

# eliminar archivos y directorios no necesarios en prod
RUN rm -rf test && rm -rf node_modules

#  unicamente las dependencia de prod
RUN npm install --prod

# comando run de la imagen
CMD ["node", "app.js"]