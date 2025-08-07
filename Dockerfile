FROM debian:stable-slim

LABEL org.opencontainers.image.authors "Weiwei Chen <wchen@mpifr-bonn.mpg.de>"
LABEL org.opencontainers.image.source https://github.com/wchenastro/mosaic

RUN apt-get update && \
    apt-get --no-install-recommends -y install \
    python3-pip python3-setuptools python3-wheel \
    python3-venv python3-dev build-essential git

RUN mkdir /src && cd /src && \
    python3 -m venv venv && . venv/bin/activate && \
    pip install numpy==2.3.2 scipy==1.16.1 contourpy==1.3.3 \
                katpoint==0.10.2 matplotlib==3.10.5 nvector==1.0.1 \
                astropy==7.1.0 && \
    git clone https://github.com/wchenastro/mosaic && \
    cd mosaic && git checkout 1.7.0 && \
    pip install -e .

ARG USERNAME=appuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

USER $USERNAME

ENTRYPOINT ["/src/venv/bin/python3", "/src/Mosaic/example/maketiling.py"]
CMD ["--help"]
