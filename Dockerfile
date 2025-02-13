# stage 1 - build app
FROM maven:3.8.4-openjdk-17-slim AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src

# install dependencies
RUN mvn clean package -DskipTests

# stage 2 - create runtime image
FROM openjdk:17-jdk-slim

WORKDIR /app

COPY --from=build /app/target/my-app-${{ env.VERSION }}.jar /app/my-app.jar

ENTRYPOINT ["java", "-jar", "/app/my-app.jar"]