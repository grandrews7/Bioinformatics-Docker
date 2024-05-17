FROM rocker/ml-verse:4.4.0
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ="America/New_York"


RUN apt-get update && \
    apt-get install -y \
    build-essential \
    python3 python3-dev python3-pip \
    bedtools \
    wget \
    git    

RUN pip install --upgrade pip && \
    pip install --no-cache-dir \
    tensorflow \
    tensorflow-probability \
    scikit-learn \
    scikeras \
    pyfaidx \
    pyBigWig \
    jupyterlab \
    scipy \
    matplotlib \
    umap-learn \
    logomaker \
    pysam \
    pandas \
    tqdm \
    plotnine \
    snakemake \
    HTSeq \
    pyGenomeTracks \
    mpl-scatter-density \
    deeptools \
    statsmodels \
    CrossMap \
    matplotlib-venn \
    biopython \
    panel \
    bokeh \
    biotite \
    upsetplot \
    scanpy \
    pympl \
    imageio \
    wordcloud \
    distfit \
    lckr-jupyterlab-variableinspector \
    jupyter-resource-usage \
    jupyterlab-spreadsheet-editor \
    jupyterlab_execute_time \
    jupyter_ai \
    openai \
    xkcdpass \
    bioframe \
    pybigtools \
    opencv-python \
    karyopype \
    bio-gopher \
    fuzzywuzzy \
    ipympl \
    duckdb \
    karyopype \
    seaborn \
    polars \
    datashader \
    holoviews \
    hvplot \
    colorcet \
    lumen \
    geoviews \
    param \
    plotly \
    pygal \
    altair
    
RUN pip install pynndescent==0.5.8 --force-reinstall
    
RUN R -e "options(warn=2); install.packages(c('tidyverse', 'ape', 'phylotools', 'ggsci', 'ggstatsplot', 'gganimate', 'ggthemes', 'ggrepel', 'ggforce', 'cowplot', 'shiny', 'BiocManager', 'tidytree', 'data.table', 'scales', 'DT', 'pheatmap', 'ggwordcloud', 'wordcloud', 'wordcloud2', 'microplot', 'rmeta', 'plotly', 'devtools', 'ggstar', 'ggnewscale', 'ggalluvial', 'TDbook', 'aplot', 'patchwork', 'igraph', 'ggraph', 'R.utils', 'ggpubr', 'UpSetR', 'ComplexUpset', 'ggVennDiagram', 'IRkernel'))"

RUN R -e "options(warn=2); IRkernel::installspec(user=F)"

RUN R -e "BiocManager::install(c('treeio', 'DESeq2', 'edgeR', 'org.Mm.eg.db', 'org.Hs.eg.db', 'org.Dm.eg.db', 'org.Ce.eg.db', 'BSgenome.Hsapiens.UCSC.hg38', 'BSgenome.Mmusculus.UCSC.mm10', 'DEXSeq', 'phyloseq', 'dada2'))"


RUN R -e 'options(warn=2); devtools::install_github("omarwagih/ggseqlogo")'

RUN R -e "options(warn=2); remotes::install_github('YuLab-SMU/ggtree')"
RUN R -e "options(warn=2); remotes::install_github('YuLab-SMU/aplot')"
RUN R -e "options(warn=2); devtools::install_github('ianmoran11/mmtable2')"

RUN mkdir /opt/meme
ADD http://meme-suite.org/meme-software/5.4.1/meme-5.4.1.tar.gz /opt/meme
WORKDIR /opt/meme/
RUN tar zxvf meme-5.4.1.tar.gz && rm -fv meme-5.4.1.tar.gz
RUN cd /opt/meme/meme-5.4.1 && \
     ./configure --prefix=/opt  --enable-build-libxml2 --enable-build-libxslt  && \
     make && \
     make install && \
     rm -rfv /opt/meme

ENV PATH="/opt/libexec/meme-5.4.1:/opt/bin:${PATH}"

RUN apt-get update && apt-get install -y libncurses5-dev
RUN cd /usr/bin && \
     wget https://github.com/samtools/samtools/releases/download/1.17/samtools-1.17.tar.bz2 && \
     tar -vxjf samtools-1.17.tar.bz2 && \
     cd samtools-1.17 && \
     ./configure --prefix=/usr/bin/samtools && \
     make && \
     make install

# Kent
RUN for i in wigToBigWig bedGraphToBigWig liftOver bigBedToBed bigWigToBedGraph; do \
     wget -q http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/$i -O /bin/$i ; chmod +x /bin/$i ; done

RUN pip install bash_kernel && \
    python3 -m bash_kernel.install


ENV PATH="/usr/bin/samtools/bin:${PATH}"
RUN R -e 'options(warn=2); install.packages("ggseqlogo")'
CMD ["/bin/bash"]