# syntax=docker/dockerfile:1

FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /workspace

COPY backend/pom.xml ./backend/pom.xml
RUN mvn -f ./backend/pom.xml dependency:go-offline

COPY backend/src ./backend/src
RUN mvn -f ./backend/pom.xml -DskipTests clean package

FROM eclipse-temurin:17-jre
WORKDIR /app

COPY --from=build /workspace/backend/target/*.jar /app/app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
