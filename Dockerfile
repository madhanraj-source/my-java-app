FROM openjdk:11-jre-slim
COPY target/my-java-app-1.0-SNAPSHOT.jar /my-java-app.jar
ENTRYPOINT ["java", "-jar", "/my-java-app.jar"]

