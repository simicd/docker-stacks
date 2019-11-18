# Source: https://hub.docker.com/r/jupyter/pyspark-notebook
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=jupyter/scipy-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

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
    JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

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


### Set the working directory to /powershell
WORKDIR /powershell

# Install .NET Core 3.0 and PowerShell
# Source: https://dotnet.microsoft.com/download/linux-package-manager/ubuntu18-04/sdk-3.0.100
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    sudo dpkg -i packages-microsoft-prod.deb && \
    sudo apt-get update && \
    sudo apt-get install -y software-properties-common && \
    sudo apt-get update && \
    sudo add-apt-repository universe && \
    sudo apt-get update && \
    sudo apt-get install apt-transport-https && \
    sudo apt-get update && \
    sudo apt-get install -y dotnet-sdk-3.0 && \
    sudo apt-get install -y powershell && \
    rm packages-microsoft-prod.deb && \
    apt-get clean

# Upgrade git to newest version
RUN sudo add-apt-repository ppa:git-core/ppa -y && \
    sudo apt-get update && \
    sudo apt-get install git -y

# Switch from root/superuser to normal user and change directory
WORKDIR /home/$NB_USER
USER $NB_UID

# Install pyarrow
RUN conda install --quiet -y 'pyarrow' && \
    conda clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# # Install and activate Jupyter extensions
RUN pip install jupyter_contrib_nbextensions && \
    jupyter contrib nbextension install --user && \
    jupyter nbextensions_configurator enable --user && \
    pip install RISE && \
    jupyter-nbextension enable rise --py --user && \
    jupyter-nbextension enable collapsible_headings/main --user && \
    jupyter-nbextension enable scratchpad/main --user && \
    jupyter-nbextension enable hide_input_all/main --user && \
    jupyter-nbextension enable hide_input/main --user && \
    jupyter-nbextension enable comment-uncomment/main --user && \
    jupyter-nbextension enable code_prettify/code_prettify --user && \
    jupyter-nbextension enable toc2/main --user && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# # Install additional Python packages
RUN pip install pyarrow --upgrade && \
    pip install koalas --upgrade && \
    pip install streamlit --upgrade && \
    pip install pytest-cov --upgrade && \
    pip install sphinx --upgrade && \
    pip install requests-kerberos --upgrade && \
    pip install yapf --upgrade

# Add custom styling for Jupyter notebook - create folder, change to that folder and download custom.css from GitHub gist
RUN mkdir -p /home/$NB_USER/.jupyter/custom && \
    cd /home/$NB_USER/.jupyter/custom && \
    wget -q https://gist.githubusercontent.com/simicd/20d40cae61305aecdf372c4ac0cffc4a/raw/082096fe90fd58095f84aab9030fa8a643713ec3/custom.css

WORKDIR $HOME
