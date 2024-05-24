FROM tomcat:9.0-slim
WORKDIR /opt
ENV APP_HOME=/usr/local/tomcat
ENV PORT=8080
ENV DB_HOST=database-1.c7ko42wuoka1.us-east-1.rds.amazonaws.com
ENV DB_PORT=3306
ENV DB_NAME=studentapp
ENV DB_USER=admin
ENV DB_PASSWORD=admin123
ADD https://piyubucket.s3.amazonaws.com/student.war $APP_HOME/webapps/
ADD  https://piyubucket.s3.amazonaws.com/mysql-connector.jar $APP_HOME/lib
COPY config /opt
RUN sed -i '20r /opt/config' /usr/local/tomcat/conf/context.xml
EXPOSE $PORT
CMD ["catalina.sh", "run"]