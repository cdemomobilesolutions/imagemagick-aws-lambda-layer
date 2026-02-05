FROM public.ecr.aws/sam/build-python3.13:latest

WORKDIR /build

COPY Makefile ./

RUN dnf update -y
RUN dnf groupinstall -y "Development Tools"
RUN dnf install -y cmake

RUN make all

WORKDIR /opt

# archive with symbolic links
RUN zip -ry /build/imagemagick-layer.zip .

RUN mkdir /dist && \
 echo "cp /build/imagemagick-layer.zip /dist/imagemagick-layer.zip" > /entrypoint.sh && \
 chmod +x /entrypoint.sh

ENTRYPOINT "/entrypoint.sh"