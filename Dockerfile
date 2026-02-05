FROM public.ecr.aws/sam/build-python3.13:latest

WORKDIR /build

COPY Makefile ./

RUN dnf update -y
RUN dnf groupinstall -y "Development Tools"
RUN dnf install -y cmake
RUN dnf install -y libffi libffi-devel python3 python3-pip

RUN make all

RUN pip3 install wand -t /opt/python
RUN pip3 install python-magic -t /opt/python

WORKDIR /opt

# archive with symbolic links
RUN zip -ry /build/imagemagick-layer.zip .

RUN mkdir /dist && \
 echo "cp /build/imagemagick-layer.zip /dist/imagemagick-layer.zip" > /entrypoint.sh && \
 chmod +x /entrypoint.sh

ENTRYPOINT "/entrypoint.sh"