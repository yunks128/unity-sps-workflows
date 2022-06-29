FROM verdi:unity-v0.0.1 

RUN pip install cwltool cwl-runner

CMD ["tail", "-f", "/dev/null"]
