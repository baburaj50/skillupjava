# Use official OpenJDK base image
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file from the local machine to the container
COPY target/*.jar app.jar

# Expose the application port (matching the one in Jenkinsfile)
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "app.jar"]
