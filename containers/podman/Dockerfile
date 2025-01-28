# Dockerfile

# specify the base image that we're building the image on top of
# from https://hub.docker.com/_/almalinux
FROM almalinux:9

# set some variables
USER $USER
WORKDIR $PWD
ENV TERM=xterm-256color

# install the software we want
RUN yum install -y python3.12 && yum install -y pip && yum install -y ncurses

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install \
    numpy \
    matplotlib \
    seaborn \
    scikit-learn

# copy everything in the current directory into /home inside the container
COPY . /home

# run the command
CMD ["/bin/bash"]