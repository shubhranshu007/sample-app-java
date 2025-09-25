# -----------------------
# Stage 1: Build with Maven
# -----------------------
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copy pom.xml and download dependencies first (caching)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code and build
COPY src ./src
RUN mvn clean package -DskipTests

# -----------------------
# Stage 2: Run with OpenJDK
# -----------------------
FROM openjdk:17-jre-slim

WORKDIR /app

# Copy only the JAR from the build stage
COPY --from=build /app/target/my-sample-app-1.0-SNAPSHOT.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
