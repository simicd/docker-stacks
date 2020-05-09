# Source: https://hub.docker.com/r/jupyter/pyspark-notebook
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=jupyter/scipy-notebook
FROM $BASE_CONTAINER

LABEL maintainer="simicd"

# Fix DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# Spark dependencies
ENV APACHE_SPARK_VERSION=3.0.0 \
    HADOOP_VERSION=3.2

RUN apt-get -y update && \
    apt-get install --no-install-recommends -y openjdk-11-jre-headless ca-certificates-java && \
    rm -rf /var/lib/apt/lists/*

# Using the preferred mirror to download Spark
WORKDIR /tmp

# hadolint ignore=SC2046
RUN wget -q $(wget -qO- https://www.apache.org/dyn/closer.lua/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz\?as_json | \
    python -c "import sys, json; content=json.load(sys.stdin); print(content['preferred']+content['path_info'])") && \
    echo "BFE45406C67CC4AE00411AD18CC438F51E7D4B6F14EB61E7BF6B5450897C2E8D3AB020152657C0239F253735C263512FFABF538AC5B9FFFA38B8295736A9C387 *spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" | sha512sum -c - && \
    tar xzf "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" -C /usr/local --owner root --group root --no-same-owner && \
    rm "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"

WORKDIR /usr/local
RUN ln -s "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}" spark

# Configure Spark
ENV SPARK_HOME=/usr/local/spark
ENV PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.9-src.zip \
    SPARK_OPTS="--driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info" \
    PATH=$PATH:$SPARK_HOME/bin \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

# Mesos dependencies
# Install from the Xenial Mesosphere repository since there does not (yet)
# exist a Bionic repository and the dependencies seem to be compatible for now.
# COPY mesos.key /tmp/
# RUN apt-get -y update && \
#     apt-get install --no-install-recommends -y gnupg && \
#     apt-key add /tmp/mesos.key && \
#     echo "deb http://repos.mesosphere.io/ubuntu xenial main" > /etc/apt/sources.list.d/mesosphere.list && \
#     apt-get -y update && \
#     apt-get --no-install-recommends -y install mesos=1.2\* && \
#     apt-get purge --auto-remove -y gnupg && \
#     rm -rf /var/lib/apt/lists/*
#
# ENV MESOS_NATIVE_LIBRARY /usr/local/lib/libmesos.so

# Define USERPROFILE environment variable to match Windows so that PowerShell script can successfully run
ENV USERPROFILE /home/$NB_USER



### Set the working directory to /powershell
WORKDIR /powershell

# Install .NET Core 3.0 and PowerShell
# Source: https://docs.microsoft.com/en-us/dotnet/core/install/linux-package-manager-ubuntu-1804
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    sudo dpkg -i packages-microsoft-prod.deb && \
    sudo apt-get update && \
    sudo apt-get install -y software-properties-common && \
    sudo apt-get update && \
    sudo add-apt-repository universe && \
    sudo apt-get update && \
    sudo apt-get install apt-transport-https && \
    sudo apt-get update && \
    sudo apt-get install -y dotnet-sdk-3.1 && \
    sudo apt-get install -y powershell && \
    rm packages-microsoft-prod.deb && \
    apt-get clean

# Install Azure Functions Core Tools
RUN npm install -g azure-functions-core-tools@3 --unsafe-perm true

# Upgrade git to newest version (requires changing repository source to git-core)
RUN sudo add-apt-repository ppa:git-core/ppa -y && \
    sudo apt-get update && \
    sudo apt-get install git -y

# Copy the Spark configuration file to the conf folder where Spark is installed
# This includes for instance additional packages such as Delta Lake which will
# be included in each SparkSession
# Additionally, copy the logger settings in log4j.properties
# (set log level to WARN messages and higher instead of INFO)
COPY spark-defaults.conf $SPARK_HOME/conf/
COPY log4j.properties $SPARK_HOME/conf/


# Switch from root/superuser to normal user and change directory
WORKDIR /home/$NB_USER
USER $NB_UID

# Install pyarrow
RUN conda install --quiet -y 'pyarrow' && \
    conda clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Create the folder /repos which will be linked to a data volume with the current user
# It's possible to mount a data volume without creating the folder here first
# but then access is given to 'root' user only
RUN mkdir /home/$NB_USER/repos

# Get the PowerShell script and execute
# This installs Jupyter extensions, additional Pyton packages and applies Jupyter styling
COPY workplace-setup.ps1 /tmp/
RUN pwsh -c "/tmp/workplace-setup.ps1"

# Give permissions to the user for all files & folders under /home/username
RUN fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
