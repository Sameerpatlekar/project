# Use a base image with Java
FROM openjdk:11-jre-slim

# Set environment variables
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

# Install wget and unzip
RUN apt-get update && apt-get install -y wget unzip

# Download and install Tomcat
RUN wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.52/bin/apache-tomcat-9.0.52.tar.gz \
    && tar xzvf apache-tomcat-9.0.52.tar.gz -C /usr/local \
    && mv /usr/local/apache-tomcat-9.0.52 /usr/local/tomcat \
    && rm apache-tomcat-9.0.52.tar.gz

# Expose the port Tomcat is running on
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
