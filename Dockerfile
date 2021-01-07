FROM ucsdets/datahub-base-notebook:2020.2-stable

USER root

RUN pip install --no-cache-dir wget

RUN conda update -n base conda -y


COPY ./kernels /usr/share/datahub/kernels
RUN conda env create --file /usr/share/datahub/kernels/tf1.yml && \
	conda init bash && \
	conda run -n tf1 /bin/bash -c "ipython kernel install --name=tf1"

COPY ./tests/ /usr/share/datahub/tests/scipy-ml-notebook
RUN chmod -R +x /usr/share/datahub/tests/scipy-ml-notebook

ENV PATH="/usr/local/nvidia/bin:$PATH"

USER $NB_UID:$NB_GID
