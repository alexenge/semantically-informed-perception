FROM asachet/rocker-stan:latest

# Set some environment variables
ENV USER=rstudio \
    NB_UID=1000 \
    PAPAJA_VERSION=v0.1.0.9997 \
    EEGUTILS_VERSION=v0.5.0 \
    R_REMOTES_UPGRADE=never \
    RETICULATE_MINICONDA_ENABLED=FALSE

# Install some R and Python packages
RUN install2.r -s --error \
        cowplot \
        reticulate \
        styler \
    && R -e "remotes::install_github('crsh/papaja', ref = '${PAPAJA_VERSION}')" \
    && R -e "remotes::install_github('craddm/eegUtils', ref = '${EEGUTILS_VERSION}')" \
    && apt-get update \
    && apt-get install -y python3-pip \
    && pip3 install \
        mne==0.21.2 \
        nbrsessionproxy==0.8.0 \
        notebook==6.3.0 \
        pandas==1.1.3
        scikit-learn==0.23.2

# Set working directory
WORKDIR /home/${NB_USER}

# Copy scripts, data, and materials
COPY analysis/ analysis/
COPY data/ data/
COPY materials/ materials/

# Expose user for binder
ARG NB_USER
ARG NB_UID
USER ${NB_USER}
