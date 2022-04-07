FROM ubuntu:20.04

USER root

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ="America/Sao_Paulo"
RUN echo "$TZ" > /etc/timezone

RUN apt update
RUN apt install -y texlive \
    texinfo \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-latex-extra \
    texlive-xetex \
    texlive-publishers \
    texlive-lang-* \
    abntex

RUN apt-get clean