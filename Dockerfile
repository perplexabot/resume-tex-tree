FROM ubuntu:bionic

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && yes "12" | apt install -y texlive-latex-base curl unzip

WORKDIR /workspace

RUN curl -LO http://mirrors.ctan.org/macros/generic/dirtree/dirtree.ins && \
    curl -LO http://mirrors.ctan.org/macros/generic/dirtree/dirtree.dtx && \
    tex dirtree.ins

RUN curl -LO http://mirrors.ctan.org/macros/latex/contrib/extsizes.zip && \
    unzip extsizes.zip && \
    cp extsizes/* ./

ARG CONTAINER_SHARE
ENV CONTAINER_SHARE=$CONTAINER_SHARE
ARG STAGE_NAME
ENV STAGE_NAME=$STAGE_NAME

CMD cp "${CONTAINER_SHARE}/${STAGE_NAME}" ./"${STAGE_NAME}" && \
    pdflatex ./"${STAGE_NAME}" && \
    cp "${STAGE_NAME}.pdf" "${CONTAINER_SHARE}/"
