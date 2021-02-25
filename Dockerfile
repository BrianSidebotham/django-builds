FROM centos:centos7

WORKDIR /opt/console

ENV REDIS_HOST=redis
ENV REDIS_PORT=6379

RUN yum -y update \
    && yum -y install \
            iputils \
            graphviz \
            python3 python3-pip python3-devel \
            openssl-devel \
            libffi-devel \
            libpq-devel \
            gcc gcc-c++ make \
            openldap-devel \
            yarnpkg \
            nodejs \
            wget \
    && yum clean all \
    && python3 -m pip install --upgrade pip \
    && python3 -m pip install --upgrade wheel \
    && python3 -m pip install --upgrade unittest-xml-reporting \
    && python3 -m pip install --upgrade html-testRunner \
    && python3 -m pip install --upgrade pylint

# graphviz is only required for development where we want to pull out the model diagrams

RUN wget -q -O - https://rpm.nodesource.com/setup_10.x | bash -
RUN wget -q -O - https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo
RUN rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg \
    && yum clean all \
    && yum install -y nodejs \
            yarn

# NOTE: When you're done testing you can run pip3 freeze in order to get a list of all the
# installed versions you've tested with
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

EXPOSE 8000
CMD ["/bin/bash"]
