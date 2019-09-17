FROM 489198589229.dkr.ecr.eu-west-1.amazonaws.com/hf-baseimage

# Install Java/OpenJDK-8 Runtime Envrionment.
RUN apt-get install --no-install-recommends --yes software-properties-common wget && \
    add-apt-repository --yes ppa:openjdk-r/ppa && \
    apt-get update && \
    apt-get install --yes openjdk-8-jre-headless && \
    apt-get install locales -y && \
    update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    # Fixing failing /var/lib/dpkg/info/ca-certificates-java.postinst run.
    # Reference: https://bugs.launchpad.net/ubuntu/+source/ca-certificates-java/+bug/1396760
    /var/lib/dpkg/info/ca-certificates-java.postinst configure

# Set Java specific environment variables.
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$PATH:${JAVA_HOME}/bin

# Register trigger to apply security patches.
# No APT cleaning at this point, because images based on this one will probably use APT, too. 
ONBUILD RUN apt-get update && \
            apt-get upgrade -y -o Dpkg::Options::="--force-confold"

# Just a placeholder to make 'docker build' command happy.
CMD [""]
