FROM localstack/localstack

# Install Build Tools
RUN apk update && apk upgrade && apk --no-cache add build-base bash g++ gcc musl-dev openssl go git perl openssh curl openjdk11 python3 py3-pip openjdk11-jre

# Hack to allow for python3.7 interpreter in Localstack scripts
RUN ln -s /usr/bin/python3 /usr/bin/python3.7

# Install Terraform
RUN curl -fSL https://releases.hashicorp.com/terraform/1.0.9/terraform_1.0.9_linux_amd64.zip -o terraform.zip
RUN unzip terraform -d /opt/terraform
RUN ln -s /opt/terraform/terraform /usr/bin/terraform
RUN rm -f terraform.zip

# Install Maven
# Downloading and installing Maven
# 1- Define a constant with the version of maven you want to install
ENV MAVEN_VERSION=3.8.3

# 2- Define a constant with the working directory
ENV USER_HOME_DIR="/root"

# 3- Define the URL where maven can be downloaded from
ENV BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

# 4- Create the directories, download maven, validate the download, install it, remove downloaded file and set links
RUN mkdir -p /usr/share/maven /usr/share/maven/ref 

RUN echo "Downloading maven"
RUN curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz 

RUN echo "Unziping maven"
RUN tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1

RUN echo "Cleaning and setting links" \
RUN rm -f /tmp/apache-maven.tar.gz \
RUN ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

# 6- Define environmental variables required by Maven, like Maven_Home directory and where the maven repo is located
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
ENV PATH "$PATH:$MAVEN_HOME/bin"

ENV GOPATH="/root/.go"

# In case Localstack is used external to image
EXPOSE 4566-4597 8080

RUN ["echo", "${GOROOT}"]
RUN ["go", "version"]
RUN ["mvn", "--version" ]
RUN ["echo", "$JAVA_HOME"]
RUN ["java", "--version"]

COPY start.sh /usr/bin
RUN chmod a+x /usr/bin/start.sh

# Run Entrypoint Script
ENTRYPOINT ["start.sh"]

CMD ["/usr/bin/bash"]
