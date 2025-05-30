# Start with BioSim base image.
ARG BASE_IMAGE=latest
FROM ghcr.io/jimboid/biosim-jupyterhub-base:$BASE_IMAGE

LABEL maintainer="James Gebbie-Rayet <james.gebbie@stfc.ac.uk>"
LABEL org.opencontainers.image.source=https://github.com/jimboid/biosim-introamber-workshop
LABEL org.opencontainers.image.description="A container environment for the ccpbiosim workshop introducing AMBER."
LABEL org.opencontainers.image.licenses=MIT

ARG TARGETPLATFORM

# Switch to jovyan user.
USER $NB_USER
WORKDIR $HOME

# Export important paths.
ENV AMBERHOME=/opt/conda

# Install dependencies
RUN conda install numpy ipywidgets nglview compilers -y
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
      conda install conda-forge::ambertools -y; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
      mamba install conda-forge/osx-arm64::ambertools -y; \
    fi
RUN pip install mdtraj

# Add all of the workshop files to the home directory
RUN git clone https://github.com/CCPBioSim/introamber-workshop.git
RUN mv introamber-workshop/* . && \
    rm -r LICENSE README.md introamber-workshop Dockerfile

# Copy lab workspace
COPY --chown=1000:100 default-37a8.jupyterlab-workspace /home/jovyan/.jupyter/lab/workspaces/default-37a8.jupyterlab-workspace

# UNCOMMENT THIS LINE FOR REMOTE DEPLOYMENT
COPY jupyter_notebook_config.py /etc/jupyter/

# Always finish with non-root user as a precaution.
USER $NB_USER
