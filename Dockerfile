# ---------- Build stage ----------
FROM maven:3.9.9-eclipse-temurin-17 AS build

# Set the working directory
WORKDIR /app

# Copy pom.xml and download dependencies first (better caching)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy project source and build
COPY src ./src
RUN mvn clean package -DskipTests

# ---------- Runtime stage ----------
FROM eclipse-temurin:17-jdk-alpine

# Set working directory
WORKDIR /app

# Copy only the built JAR from the build stage
COPY --from=build /app/target/appli-0.0.1-SNAPSHOT.jar app.jar

# Expose the application port (Spring Boot default: 8080)
EXPOSE 8080

# Run the app
ENTRYPOINT ["java","-jar","app.jar"]