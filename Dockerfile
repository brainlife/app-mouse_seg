FROM ubuntu:xenial

ARG DEBIAN_FRONTEND=noninteractive

#----------------------------------------------------------
# Install common dependencies 
#----------------------------------------------------------
ENV LANG="en_US.UTF-8" \
    LC_ALL="C.UTF-8" 
RUN apt-get update -qq && apt-get install -yq --no-install-recommends  \
    	apt-utils bzip2 ca-certificates curl locales unzip git cmake wget \
        build-essential tcsh libglu1-mesa libgomp1 libjpeg62 \
        jq bc libsys-hostname-long-perl r-base vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && localedef --force --inputfile=en_US --charmap=UTF-8 C.UTF-8 \
    && chmod 777 /opt && chmod a+s /opt 

#install neurodebian
RUN wget -O- http://neuro.debian.net/lists/xenial.us-tn.full | tee /etc/apt/sources.list.d/neurodebian.sources.list

RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends --allow-unauthenticated \
                                                     fsl \
                                                     afni \
                                                     ants \
                                                     convert3d \
                                                     dcm2niix \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#install niftyreg
RUN cd /tmp && git clone git://git.code.sf.net/p/niftyreg/git niftyreg-git \
    && mkdir niftyreg_build && cd niftyreg_build \
    && cmake ../niftyreg-git -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local/ \
    && make && make install && rm -rf /tmp/niftyreg-git /tmp/niftyreg_build

#if niftyreg git repo down
#RUN mkdir -p /tmp/niftyreg-git
#ADD niftyreg-git /tmp/niftyreg-git
#RUN cd /tmp && mkdir niftyreg_build && cd niftyreg_build \
#    && cmake ../niftyreg-git -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local/ \
#    && make && make install && rm -rf /tmp/niftyreg-git /tmp/niftyreg_build

#install freesurfer WITH license
RUN curl ftp://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/6.0.0/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz | tar xvz -C /usr/local
ADD license.txt /usr/local/freesurfer/

#mimic SetUpFreeSurfer.sh
ENV FREESURFER_HOME=/usr/local/freesurfer
ENV FMRI_ANALYSIS_DIR /usr/local/freesurfer/fsfast
ENV FSFAST_HOME /usr/local/freesurfer/fsfast
ENV FUNCTIONALS_DIR /usr/local/freesurfer/sessions
ENV LOCAL_DIR /usr/local/freesurfer/local
ENV MINC_BIN_DIR /usr/local/freesurfer/mni/bin
ENV MINC_LIB_DIR /usr/local/freesurfer/mni/lib
ENV MNI_DATAPATH /usr/local/freesurfer/mni/data
ENV MNI_DIR /usr/local/freesurfer/mni
ENV MNI_PERL5LIB /usr/local/freesurfer/mni/share/perl5
ENV PERL5LIB /usr/local/freesurfer/mni/share/perl5
ENV SUBJECTS_DIR /usr/local/freesurfer/subjects
ENV PATH /usr/local/freesurfer/bin:/usr/local/freesurfer/fsfast/bin:/usr/local/freesurfer/tktools:/usr/local/freesurfer/mni/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

#add scripts
RUN mkdir /usr/local/scripts
ADD scripts /usr/local/scripts

#add atlases
RUN mkdir -p /usr/local/atlases/Mori_Atlas /usr/local/atlases/C57BL6J_BrookhavenAtlas
ADD atlases/Mori_Atlas /usr/local/atlases/Mori_Atlas
ADD atlases/C57BL6J_BrookhavenAtlas /usr/local/atlases/C57BL6J_BrookhavenAtlas

#FSL config
ENV FSLDIR=/usr/share/fsl/5.0
#simulate . ${FSLDIR}/etc/fslconf/fsl.sh
ENV PATH=$PATH:$FSLDIR/bin
ENV LD_LIBRARY_PATH=/usr/lib/fsl/5.0
ENV FSLBROWSER=/etc/alternatives/x-www-browser
ENV FSLCLUSTER_MAILOPTS=n
ENV FSLLOCKDIR=
ENV FSLMACHINELIST=
ENV FSLMULTIFILEQUIT=TRUE
ENV FSLOUTPUTTYPE=NIFTI_GZ
ENV FSLREMOTECALL=
ENV FSLTCLSH=/usr/bin/tclsh
ENV FSLWISH=/usr/bin/wish
ENV POSSUMDIR=/usr/share/fsl/5.0

#afni and ants
ENV PATH=/usr/lib/ants:/usr/lib/afni/bin:$PATH

#install UNC tools
RUN mkdir /usr/local/UNC_tools
ADD UNC_tools /usr/local/UNC_tools/
ENV LD_LIBRARY_PATH=/usr/local/UNC_tools/lib:$LD_LIBRARY_PATH
ENV PATH=/usr/local/UNC_tools:$PATH

#make it work under singularity
RUN ldconfig && mkdir -p /N/u /N/home /N/dc2 /N/soft
