FROM amancevice/pandas
RUN groupadd -r user && useradd -r -g user user
USER user
WORKDIR /workdir
COPY resources/* ./
CMD [ "/bin/sh" ]
