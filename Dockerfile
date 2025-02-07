# Start with BioSim base image.
ARG BASE_IMAGE=latest
FROM harbor.stfc.ac.uk/biosimulation-cloud/biosim-jupyter-base:$BASE_IMAGE

LABEL maintainer="James Gebbie-Rayet <james.gebbie@stfc.ac.uk>"

# Switch to jovyan user.
USER $NB_USER
WORKDIR $HOME

# Export important paths.
ENV AMBERHOME=/opt/conda

RUN conda install -c conda-forge ambertools compilers -y
RUN conda install mdtraj numpy ipywidgets nglview -y

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
