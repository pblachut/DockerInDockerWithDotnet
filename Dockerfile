FROM docker:18.05

RUN apk add --no-cache \
        ca-certificates \
        krb5-libs \
        libgcc \
        libintl \
        libssl1.0 \
        libstdc++ \
        tzdata \
        userspace-rcu \
        zlib \
		py-pip \
    && apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache \
        lttng-ust
		
ENV ASPNETCORE_URLS=http://+:80 \
	DOTNET_RUNNING_IN_CONTAINER=true \
	DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true
	
RUN apk add --no-cache icu-libs

ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8
	
ENV DOTNET_SDK_VERSION 2.1.302

RUN apk add --no-cache --virtual .build-deps \
        openssl \
    && wget -O dotnet.tar.gz https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-sdk-$DOTNET_SDK_VERSION-linux-musl-x64.tar.gz \
    && dotnet_sha512='0f9a6fcbad609ef1ff5b398de9a1f1bf59eebc59b28a4c8cfead28f0209bf77601d05d49f5ea1223c860a803fb82cd7e2401b6df290da34e54b36bdd8788ed48' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -C /usr/share/dotnet -xzf dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
    && rm dotnet.tar.gz \
    && apk del .build-deps

	
ENV DOTNET_USE_POLLING_FILE_WATCHER=true \ 
    NUGET_XMLDOC_MODE=skip

RUN dotnet help

RUN pip install docker-compose