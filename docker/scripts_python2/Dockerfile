FROM python:2.7.10

LABEL maintainer="Ekaterina Sakharova <kates@ebi.ac.uk>"

RUN pip install --upgrade pip && pip install -q biopython==1.76

COPY MGRAST_base.py /tools/
COPY run_quality_filtering.py /tools/

RUN chmod a+x /tools/*

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/tools
