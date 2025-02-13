# stage 1 - build app
FROM maven:3.9.2-eclipse-temurin-17 AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src

# install dependencies
RUN mvn clean package -DskipTests
RUN echo "Using version: $VERSION"

# Debug: List the contents of /app/target
RUN ls -l /app/target

# stage 2 - create runtime image
FROM openjdk:17-jdk-slim

WORKDIR /app

ARG VERSION
COPY --from=build /app/target/my-app-${VERSION}.jar /app/my-app.jar


ENTRYPOINT ["java", "-jar", "/app/my-app.jar"]