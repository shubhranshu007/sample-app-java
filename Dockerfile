# -----------------------
# Stage 1: Build with Maven (OpenJDK)
# -----------------------
FROM maven:3.9.6-openjdk-17 AS build

# Set working directory inside the container
WORKDIR /app

# Copy pom.xml and download dependencies first (for caching)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# -----------------------
# Stage 2: Run the JAR (OpenJDK)
# -----------------------
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy the JAR from the build stage
COPY --from=build /app/target/my-sample-app-1.0-SNAPSHOT.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
