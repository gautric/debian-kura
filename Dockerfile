#
# Licensed to the Rhiot under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM debian

MAINTAINER Greg AUTRIC <gautric@redhat.com>

## to build it
## sudo docker build -t debian-kura .
## to run it
## sudo docker run -i -t debian-kura -p 80:80

## Variable ENV
ENV JAVA_VERSION=${JAVA_VERSION:-7}
ENV KURA_VERSION=${KURA_VERSION:-1.3.0}
ENV RPI_VERSION=${RPI_VERSION:-raspberry-pi-bplus}

## Debian/Raspbian package installation
RUN apt-get update && \
    apt-get install -y apt-utils unzip ethtool dos2unix telnet bind9 hostapd isc-dhcp-server iw monit wget openjdk-${JAVA_VERSION}-jdk && \
    rm -rf /var/lib/apt/lists/*

## Kura installation
RUN wget https://s3.amazonaws.com/kura_downloads/raspbian/release/${KURA_VERSION}/kura_${KURA_VERSION}_${RPI_VERSION}_installer.deb
RUN dpkg -i kura_${KURA_VERSION}_${RPI_VERSION}_installer.deb

## Hack for ubuntu
RUN [ -f /lib/$(arch)-linux-gnu/libudev.so.0 ] || ln -sf /lib/$(arch)-linux-gnu/libudev.so.1 /lib/$(arch)-linux-gnu/libudev.so.0

## Web and telnet
EXPOSE 80
EXPOSE 5002

CMD /opt/eclipse/kura/bin/start_kura.sh
