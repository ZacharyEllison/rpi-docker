FROM zellison/rpi-buster:base

RUN apt-get autoremove && apt-get update -y && apt-get upgrade -y
RUN apt-get install -y build-essential cmake pkg-config
RUN apt-get install -y libjpeg-dev libtiff5-dev libpng-dev
RUN apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
RUN apt-get install -y libxvidcore-dev libx264-dev
RUN apt-get install -y libfontconfig1-dev libcairo2-dev
RUN apt-get install -y libgdk-pixbuf2.0-dev libpango1.0-dev
RUN apt-get install -y libgtk2.0-dev libgtk-3-dev
RUN apt-get install -y libatlas-base-dev gfortran
RUN apt-get install -y libhdf5-dev libhdf5-serial-dev libhdf5-103
RUN apt-get install -y libqtgui4 libqtwebkit4 libqt4-test python3-pyqt5
RUN apt-get install -y python3-dev python3-pip git
RUN git clone https://github.com/jasperproject/jasper-client.git jasper && \
 		chmod +x jasper/jasper.py && \
		pip3 install --upgrade setuptools && \ 
		pip3 install -r jasper/client/requirements.txt

RUN apt-get install -y wget
RUN apt-get install -y unzip
RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/4.0.0.zip && \
    wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.0.0.zip
RUN unzip opencv.zip && unzip opencv_contrib.zip
RUN mv opencv-4.0.0 opencv && mv opencv_contrib-4.0.0 opencv_contrib
RUN mkdir opencv/build 

RUN cd opencv/build && cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules \
    -D ENABLE_NEON=ON \
    -D ENABLE_VFPV3=ON \
    -D BUILD_TESTS=OFF \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D BUILD_EXAMPLES=OFF ..

RUN cd opencv/build && make && make install && ldconfig

CMD ["/bin/bash", "python3 -c 'import cv2; print(cv2.__version__)'"]