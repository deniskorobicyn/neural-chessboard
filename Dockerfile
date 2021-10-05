FROM amd64/python:3.5

RUN mkdir /src
WORKDIR /src

RUN apt-get update
RUN apt-get upgrade -y
RUN apt install -y build-essential cmake git pkg-config libgtk-3-dev \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev \
    gfortran openexr libatlas-base-dev python3-dev python3-numpy \
    libtbb2 libtbb-dev libdc1394-22-dev

COPY ./requirements.txt /src/requirements.txt
RUN pip3 install -r /src/requirements.txt

RUN mkdir /opencv_build
RUN cd /opencv_build && git clone https://github.com/opencv/opencv.git
RUN cd /opencv_build && git clone https://github.com/opencv/opencv_contrib.git
RUN cd /opencv_build/opencv && git checkout 3.4
RUN cd /opencv_build/opencv_contrib && git checkout 3.4
RUN mkdir /opencv_build/opencv/build
RUN cd /opencv_build/opencv/build && cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D OPENCV_EXTRA_MODULES_PATH=/opencv_build/opencv_contrib/modules .. && \
    make -j2 && \
    make install