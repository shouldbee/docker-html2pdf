FROM shouldbee/baseimage-go

ADD wkhtmltox-0.12.1_linux-trusty-amd64.deb /tmp/wkhtmltox-0.12.1_linux-trusty-amd64.deb

RUN sudo apt-get update -q && apt-get install -y libjpeg-turbo8 fontconfig fonts-ipafont
RUN cd /tmp && dpkg -i wkhtmltox-0.12.1_linux-trusty-amd64.deb && rm -rf wkhtmltox-0.12.1_linux-trusty-amd64.deb

ADD build/linux-amd64/html2pdf /usr/bin/html2pdf

CMD /usr/bin/html2pdf
