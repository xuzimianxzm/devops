FROM gradle:6.8-jdk11-hotspot as buildBootJar
WORKDIR /home/gradle/project
COPY ./code/java/web_demo .
RUN gradle bootJar

FROM openjdk:11
WORKDIR /usr/src/myapp
COPY --from=buildBootJar /home/gradle/project/build/libs/demo-0.0.1-SNAPSHOT.jar .
EXPOSE 8080
CMD ["java", "-jar" ,"demo-0.0.1-SNAPSHOT.jar"]