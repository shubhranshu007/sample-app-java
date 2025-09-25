# -----------------------
# Stage 1: Build with Maven
# -----------------------
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

# -----------------------
# Stage 2: Run with OpenJDK Slim
# -----------------------
FROM openjdk:17-slim

WORKDIR /app
COPY --from=build /app/target/my-sample-app-1.0-SNAPSHOT.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
