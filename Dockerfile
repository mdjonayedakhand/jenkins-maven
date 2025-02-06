FROM openjdk:25-oraclelinux9
WORKDIR /opt/app
COPY target/jonayed.jar app.jar
ENTRYPOINT ["java","-jar","app.jar"]
