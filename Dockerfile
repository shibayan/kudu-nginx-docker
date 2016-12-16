FROM debian:jessie

# Install nginx
RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
	&& echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install -y nginx --no-install-recommends

# Install Mono
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
  --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
  && echo "deb http://download.mono-project.com/repo/debian wheezy main" > \
  /etc/apt/sources.list.d/mono-xamarin.list \
  && echo "deb http://download.mono-project.com/repo/debian wheezy-libjpeg62-compat main" >> \
  /etc/apt/sources.list.d/mono-xamarin.list \
  && apt-get update \
  && apt-get install -y apt-utils --no-install-recommends \
  && apt-get install -y wget --no-install-recommends \
  && apt-get install -y unzip --no-install-recommends \
  && apt-get install -y xz-utils --no-install-recommends \
  && apt-get install -y mono-complete --no-install-recommends \
  && apt-get install -y mono-fastcgi-server4 --no-install-recommends \
  && apt-get install -y git --no-install-recommends \
  && apt-get install -y openssh-client --no-install-recommends \
  && wget -O /tmp/Kudu.zip https://nildev.blob.core.windows.net/kudu/1.0/Kudu.zip \
  && wget -O /tmp/node-v4.4.7-linux-x64.tar.xz https://nodejs.org/dist/v4.4.7/node-v4.4.7-linux-x64.tar.xz \
  && wget -O /tmp/node-v4.5.0-linux-x64.tar.xz https://nodejs.org/dist/v4.5.0/node-v4.5.0-linux-x64.tar.xz \
  && wget -O /tmp/node-v6.2.2-linux-x64.tar.xz https://nodejs.org/dist/v6.2.2/node-v6.2.2-linux-x64.tar.xz \
  && wget -O /tmp/node-v6.6.0-linux-x64.tar.xz https://nodejs.org/dist/v6.6.0/node-v6.6.0-linux-x64.tar.xz \
  && wget -O /tmp/node-v6.9.1-linux-x64.tar.xz https://nodejs.org/dist/v6.9.1/node-v6.9.1-linux-x64.tar.xz \
  && wget -O /tmp/npm-2.15.8.zip https://github.com/npm/npm/archive/v2.15.8.zip \
  && wget -O /tmp/npm-2.15.9.zip https://github.com/npm/npm/archive/v2.15.9.zip \
  && wget -O /tmp/npm-3.9.5.zip https://github.com/npm/npm/archive/v3.9.5.zip \
  && wget -O /tmp/npm-3.10.3.zip https://github.com/npm/npm/archive/v3.10.3.zip \
  && wget -O /tmp/npm-3.10.8.zip https://github.com/npm/npm/archive/v3.10.8.zip 

# Install npm and node
RUN mkdir -p /opt/npm/2.15.8/node_modules \
  && unzip -q /tmp/npm-2.15.8.zip -d /opt/npm/2.15.8/node_modules \
  && mv /opt/npm/2.15.8/node_modules/npm-2.15.8 /opt/npm/2.15.8/node_modules/npm \
  && ln -s /opt/npm/2.15.8/node_modules/npm/bin/npm /opt/npm/2.15.8/npm \
  && chmod -R 755 /opt/npm/2.15.8/node_modules/npm/bin \
  && mkdir -p /opt/npm/2.15.9/node_modules \
  && unzip -q /tmp/npm-2.15.9.zip -d /opt/npm/2.15.9/node_modules \
  && mv /opt/npm/2.15.9/node_modules/npm-2.15.9 /opt/npm/2.15.9/node_modules/npm \
  && ln -s /opt/npm/2.15.9/node_modules/npm/bin/npm /opt/npm/2.15.9/npm \
  && chmod -R 755 /opt/npm/2.15.9/node_modules/npm/bin \
  && mkdir -p /opt/npm/3.9.5/node_modules \
  && unzip -q /tmp/npm-3.9.5.zip -d /opt/npm/3.9.5/node_modules \
  && mv /opt/npm/3.9.5/node_modules/npm-3.9.5 /opt/npm/3.9.5/node_modules/npm \
  && ln -s /opt/npm/3.9.5/node_modules/npm/bin/npm /opt/npm/3.9.5/npm \
  && chmod -R 755 /opt/npm/3.9.5/node_modules/npm/bin \
  && mkdir -p /opt/npm/3.10.3/node_modules \
  && unzip -q /tmp/npm-3.10.3.zip -d /opt/npm/3.10.3/node_modules \
  && mv /opt/npm/3.10.3/node_modules/npm-3.10.3 /opt/npm/3.10.3/node_modules/npm \
  && ln -s /opt/npm/3.10.3/node_modules/npm/bin/npm /opt/npm/3.10.3/npm \
  && chmod -R 755 /opt/npm/3.10.3/node_modules/npm/bin \
  && mkdir -p /opt/npm/3.10.8/node_modules \
  && unzip -q /tmp/npm-3.10.8.zip -d /opt/npm/3.10.8/node_modules \
  && mv /opt/npm/3.10.8/node_modules/npm-3.10.8 /opt/npm/3.10.8/node_modules/npm \
  && ln -s /opt/npm/3.10.8/node_modules/npm/bin/npm /opt/npm/3.10.8/npm \
  && chmod -R 755 /opt/npm/3.10.8/node_modules/npm/bin \
  && chown -R root:root /opt/npm \
  && mkdir -p /opt/nodejs \
  && tar xfJ /tmp/node-v4.4.7-linux-x64.tar.xz -C /opt/nodejs \
  && rm -f node-v4.4.7-linux-x64.tar.xz \
  && mv /opt/nodejs/node-v4.4.7-linux-x64 /opt/nodejs/4.4.7 \
  && echo "2.15.8" > /opt/nodejs/4.4.7/npm.txt \
  && mkdir -p /opt/nodejs \
  && tar xfJ /tmp/node-v4.5.0-linux-x64.tar.xz -C /opt/nodejs \
  && rm -f node-v4.5.0-linux-x64.tar.xz \
  && mv /opt/nodejs/node-v4.5.0-linux-x64 /opt/nodejs/4.5.0 \
  && echo "2.15.9" > /opt/nodejs/4.5.0/npm.txt \
  && tar xfJ /tmp/node-v6.2.2-linux-x64.tar.xz -C /opt/nodejs \
  && rm -f node-v6.2.2-linux-x64.tar.xz \
  && mv /opt/nodejs/node-v6.2.2-linux-x64 /opt/nodejs/6.2.2 \
  && echo "3.9.5" > /opt/nodejs/6.2.2/npm.txt \
  && tar xfJ /tmp/node-v6.6.0-linux-x64.tar.xz -C /opt/nodejs \
  && rm -f node-v6.6.0-linux-x64.tar.xz \
  && mv /opt/nodejs/node-v6.6.0-linux-x64 /opt/nodejs/6.6.0 \
  && echo "3.10.3" > /opt/nodejs/6.6.0/npm.txt \
  && tar xfJ /tmp/node-v6.9.1-linux-x64.tar.xz -C /opt/nodejs \
  && rm -f node-v6.9.1-linux-x64.tar.xz \
  && mv /opt/nodejs/node-v6.9.1-linux-x64 /opt/nodejs/6.9.1 \
  && echo "3.10.8" > /opt/nodejs/6.9.1/npm.txt \
  && chown -R root:root /opt/nodejs \
  && ln -s /opt/nodejs/6.9.1/bin/node /opt/nodejs/node \
  && ln -s /opt/nodejs/6.9.1/npm.txt /opt/nodejs/npm.txt \
  && rm -f /usr/bin/node \
  && ln -s /opt/nodejs/6.9.1/bin/node /usr/bin/node \
  && rm -f /opt/nodejs/6.9.1/bin/npm \
  && ln -s /opt/npm/3.10.8/node_modules/npm/bin/npm /opt/nodejs/npm \
  && ln -s /opt/npm/3.10.8/node_modules /opt/nodejs/node_modules \
  && rm -rf /usr/bin/npm \
  && ln -s /opt/npm/3.10.8/node_modules/npm/bin/npm /usr/bin/npm \
  && ln -s /opt/npm/3.10.8/node_modules /usr/bin/node_modules

# Install Kudu
RUN npm install -g kudusync \
  && ln -s /opt/nodejs/6.9.1/bin/kudusync /usr/bin/kudusync \
  && unzip -q -o /tmp/Kudu.zip \
  && cp -rf ./SiteExtensions/* /opt \
  && rm -f /tmp/Kudu.zip \
  && rm -rf ./SiteExtensions \
  && cat /opt/Kudu/Web.config | \
  sed 's|  <location path="." inheritInChildApplications="false">|  <location path="~/../../../opt/Kudu" inheritInChildApplications="false">|' > /opt/Kudu/Web.config2 \
  && mv /opt/Kudu/Web.config2 /opt/Kudu/Web.config \
  && chmod 755 /opt/Kudu/bin/kudu.exe \
  && chmod 755 /opt/Kudu/bin/node_modules/.bin/kuduscript \
  && mkdir -p /opt/Kudu/local \
  && chmod 755 /opt/Kudu/local

# Upgrade mono
RUN echo "deb http://download.mono-project.com/repo/debian beta/snapshots/c7-ms/. main" | tee /etc/apt/sources.list.d/mono-xamarin-c7-ms.list \
  && apt-get update \
  && apt-get install -y libmono-system-net-http-webrequest4.0-cil --no-install-recommends

# Install Supervisor
RUN apt-get install -y supervisor \
  && mkdir -p /var/log/supervisor

# Copy Setting
COPY default.conf /etc/nginx/conf.d/default.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV MONO_IOMAP=all HOME=/home APPSETTING_SCM_USE_LIBGIT2SHARP_REPOSITORY=0 KUDU_APPPATH=/opt/Kudu KUDU_MSBUILD=/usr/bin/xbuild APPDATA=/opt/Kudu/local SCM_BIN_PATH=/opt/Kudu/bin

EXPOSE 80

CMD ["/usr/bin/supervisord"]