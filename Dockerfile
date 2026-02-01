# We use Eclipse Temurin (the new standard for OpenJDK)
FROM eclipse-temurin:11-jre-focal

# Copy the JAR file
COPY target/*.jar app.jar

# Open the port
EXPOSE 8080

# Run the App
ENTRYPOINT ["java", "-jar", "/app.jar"]