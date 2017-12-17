FROM armv7/armhf-ubuntu:16.04

#Development Tools
RUN apt-get update && \
    apt-get install -y tmux \
                       wget zip unzip curl \
                       bash-completion git \
                       software-properties-common 

#Japanese Settings
RUN apt-get update -y
RUN apt-get -y install language-pack-ja-base language-pack-ja ibus-mozc && \
    update-locale LANG=ja_JP.UTF-8 && \
    apt-get install -y fonts-takao fonts-takao-gothic fonts-takao-pgothic fonts-takao-mincho
# Keyboard Settings
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y -qq keyboard-configuration && \
    sed -i -e 's/^XKBMODEL="pc105"/XKBMODEL="macbook79"/g' /etc/default/keyboard && \
    sed -i -e 's/^XKBLAYOUT="us"/XKBLAYOUT="jp"/g' /etc/default/keyboard && \
    sed -i -e 's/^XKBVARIANT=""/XKBVARIANT="OADG109A"/g' /etc/default/keyboard
ENV TZ="Asia/Tokyo"
ENV LANG ja_JP.UTF-8
#ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
ENV LC_CTYPE ja_JP.UTF-8

# User scripts path
RUN mkdir -p ~/bin && \
    echo "# set PATH so it includes user's private bin if it exists" >> ~/.profile && \
    echo "if [ -d \"\$HOME/bin\" ] ; then" >> ~/.profile && \
    echo "    PATH=\"\$HOME/bin:\$PATH\"" >> ~/.profile && \
    echo "fi" >> ~/.profile

# Vim
RUN apt-get install -y  vim-nox && \
    curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh -o /tmp/install.sh
WORKDIR /tmp
RUN /bin/bash -c "sh ./install.sh" && \
    git clone https://github.com/tomasr/molokai && \
    mkdir -p ~/.vim/colors && \
    cp ./molokai/colors/molokai.vim ~/.vim/colors/
COPY .vimrc /root/.vimrc

# Tmux
WORKDIR /tmp
COPY .tmux.conf /root/.tmux.conf

# QtCreator
RUN apt-get update && apt-get install -y qtcreator

# Pycharm
RUN apt-get update && apt-get install -y openjdk-8-jdk
WORKDIR /opt
ARG PYCHARM_VERSION=2017.2.4
RUN wget https://download.jetbrains.com/python/pycharm-community-$PYCHARM_VERSION.tar.gz && \
    tar -zxvf pycharm-community-$PYCHARM_VERSION.tar.gz && \
    rm pycharm-community-$PYCHARM_VERSION.tar.gz
RUN mv pycharm-community-$PYCHARM_VERSION pycharm-community && \
    touch /usr/local/bin/pycharm && \
    echo "#!/bin/bash" >> /usr/local/bin/pycharm-ros && \
    echo "bash -i -c \"/opt/pycharm-community/bin/pycharm.sh\" %f" >> /usr/local/bin/pycharm && \
    chmod u+x /usr/local/bin/pycharm

# VS Code
WORKDIR /tmp
RUN apt-get install -y sudo apt-transport-https && \
    wget -O - https://code.headmelted.com/installers/apt.sh > install-vscode.sh && \
    chmod +x install-vscode.sh && \
    ./install-vscode.sh &&\
    rm install-vscode.sh
RUN touch /usr/local/bin/code-oss-as-root && \
    echo "#!/bin/bash" >> /usr/local/bin/code-oss-as-root && \
    echo "code-oss --user-data-dir=\"/root\" \$@" >> /usr/local/bin/code-oss-as-root && \
    chmod +x /usr/local/bin/code-oss-as-root

WORKDIR /root
CMD ["/bin/bash"]
