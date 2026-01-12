# ---------- Build stage ----------
FROM eclipse-temurin:11-jdk AS BUILD_IMAGE

RUN apt-get update && apt-get install -y maven \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN mvn clean package -DskipTests


# ---------- Runtime stage ----------
FROM tomcat:9.0-jdk11-temurin

LABEL Project="Vprofile"
LABEL Author="Imran"

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=BUILD_IMAGE /app/target/vprofile-v2.war \
  /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
