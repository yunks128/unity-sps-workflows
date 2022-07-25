# FROM lucacinquini/sounder_sips_l1b_pge:r0.1.0
FROM hysds/pge-base:develop

# provision
# USER ops
# COPY . /home/ops/verdi/ops/hello_world_pge

# set entrypoint
#ENTRYPOINT ["/entrypoint-pge-with-stats.sh"]

# WORKDIR /home/ops
# CMD ["/bin/bash", "--login"]

# RUN pip3 install cwl-runner
RUN /home/ops/verdi/bin/pip install cwl-runner

# COPY sounder_sips/ssips_L1b_workflow.cwl /src/ssips_L1b_workflow.cwl
# COPY sounder_sips/ssips_L1b_workflow.yml /src/ssips_L1b_workflow.yml
# COPY ./sounder_sips/ /home/ops
COPY ./sounder_sips/ /src

ENTRYPOINT ["/home/ops/verdi/bin/cwl-runner"]
# ENTRYPOINT ["cwl-runner"]