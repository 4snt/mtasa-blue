# Use uma base leve
FROM debian:bullseye-slim

# Definir diretório de trabalho
WORKDIR /mtasa

# Instalar dependências
RUN apt-get update && apt-get install -y \
    wget \
    tar \
    libncurses6 \
    libreadline8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Baixar servidor MTA:SA (versão “latest”)
RUN wget https://nightly.mtasa.com/linux/x64/multitheftauto_linux_x64-latest.tar.gz -O /tmp/mtasa.tar.gz \
    && tar -xzvf /tmp/mtasa.tar.gz \
    && mv multitheftauto_linux_x64* mtasa-server \
    && rm /tmp/mtasa.tar.gz

# Definir diretório interno do servidor
WORKDIR /mtasa/mtasa-server

# Expor as portas necessárias:
# - Porta de jogo UDP
# - Porta de masterlist UDP
# - Porta http/tcp de downloads ou admin
EXPOSE 22003/udp
EXPOSE 22126/udp
EXPOSE 22005/tcp

# Volumes para dados persistentes (configurações, recursos, registros)
VOLUME ["/data", "/resources", "/resource-cache", "/native-modules"]

# Variáveis de ambiente básicas (você pode adaptar conforme preferir)
ENV SERVER_NAME="MeuServidor MTA" \
    SERVER_PORT=22003 \
    RESOURCE_URL="http://mirror.mtasa.com/mtasa/resources/mtasa-resources-latest.zip"

# Entrada principal
ENTRYPOINT ["./mta-server64"]

# Parâmetro padrão (você pode modificá-lo por ENV ou args no Coolify)
CMD ["-x", "-n", "-u"]
