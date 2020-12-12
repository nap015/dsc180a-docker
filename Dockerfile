FROM ucsdets/datahub-base-notebook:2020.2-stable

USER root

# tensorflow, pytorch stable versions
# https://pytorch.org/get-started/previous-versions/
# https://www.tensorflow.org/install/source#linux

# RUN conda install cudatoolkit=10.0 \
# 				  cudnn \
# 				  nccl \
# 				  -y

# # Install pillow<7 due to dependency issue https://github.com/pytorch/vision/issues/1712
# RUN pip install --no-cache-dir tensorflow-gpu==1.15 \
# 								datascience \
# 								PyQt5 \
# 								scapy \
# 								nltk \
# 								opencv-contrib-python-headless==3.4.5.20 \
# 								jupyter-tensorboard \
# 								opencv-python \
# 								pycocotools \
# 								"pillow<7"

# # torch must be installed separately since it requires a non-pypi repo. See stable version above
# RUN pip install --no-cache-dir torch==1.2.0 torchvision==0.4.0 -f https://download.pytorch.org/whl/torch_stable.html
# RUN jupyter tensorboard enable --sys-prefix

RUN conda update -n base conda -y

COPY ./kernels /usr/share/datahub/kernels
RUN conda env create --file /usr/share/datahub/kernels/tf1.yml && \
	conda init bash && \
	conda run -n tf1 /bin/bash -c "ipython kernel install --name=tf1"

COPY ./tests/ /usr/share/datahub/tests/scipy-ml-notebook
RUN chmod -R +x /usr/share/datahub/tests/scipy-ml-notebook

ENV PATH="/usr/local/nvidia/bin:$PATH"

USER $NB_UID:$NB_GID
