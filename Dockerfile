FROM jupyter/scipy-notebook

# environment settings
ENV HOME /home/jovyan
ENV DEBIAN_FRONTEND noninteractive

USER root

RUN echo "jovyan:lithops" | chpasswd && adduser jovyan sudo && \
    usermod -a -G sudo jovyan && \
    echo 'jovyan  ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    #
    echo "**** install node and yarn repos ****" && \
    apt-get update && \
    apt-get purge python2* -y && \
    apt-get purge --auto-remove -y && \
    apt-get install -y gnupg curl && \
    curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    echo 'deb https://deb.nodesource.com/node_12.x focal main' > /etc/apt/sources.list.d/nodesource.list && \
    curl -s https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo 'deb https://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list && \
    #
    echo "**** install runtime dependencies ****" && \
    apt-get install -y \
        texlive-latex-extra \
        python3-pip \
        git \
        jq \
        nano \
        net-tools \
        nodejs \
        sudo \
        yarn \
        nginx \
        wget \
        vim && \
    #
    echo "**** install s6 overlay ****" && \
    wget https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.3/s6-overlay-amd64-installer -O /tmp/s6-overlay-amd64-installer && \
    chmod +x /tmp/s6-overlay-amd64-installer && /tmp/s6-overlay-amd64-installer / && \
    #
    echo "**** install code-server ****" && \
    curl -fsSL https://code-server.dev/install.sh | sh && \
    #
    conda install --quiet --yes -c conda-forge \
        'python-language-server' \
        'jupyterlab' \
        'texlab' \
        'chktex' \
        'jupyter-lsp' && \
    conda clean --all -f -y && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging /home/$NB_USER/.cache/yarn && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER && \
    #
    jupyter labextension install @krassowski/jupyterlab-lsp && \
    jupyter lab build --dev-build=False --minimize=True  && \
    pip3 install -U pip jupyterlab-s3-browser jedi==0.17.2 && \
    pip3 install -U git+https://github.com/lithops-cloud/lithops && \
    jupyter serverextension enable --py jupyterlab_s3_browser && \
    #
    echo "**** clean up ****" && \
    apt-get purge --auto-remove -y && \
    apt-get clean && \
    rm -rf  /tmp/* /var/lib/apt/lists/* /var/tmp/* \
            /home/$NB_USER/.cache/yarn /home/$NB_USER/.cache/pip \
            /home/$NB_USER/.cache/code-server

# add local files
COPY /root/home/ /home/
COPY /root/etc/ /etc/

ENTRYPOINT ["/init"]
