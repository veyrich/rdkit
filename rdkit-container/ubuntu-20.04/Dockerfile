FROM ubuntu:20.04 as builder

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt upgrade -y; exit 0
RUN apt install -y vim cmake g++ python3 python3-numpy libfreetype6 git
RUN apt install -y libboost-iostreams1.71.0 libboost-system1.71.0 libboost-python1.71.0 libboost-serialization1.71.0 libboost-program-options1.71.0
RUN apt install -y libeigen3-dev libboost-iostreams1.71-dev libboost-system1.71-dev libfreetype6-dev libboost-python1.71-dev libboost-serialization1.71-dev libboost-program-options1.71-dev

WORKDIR /

#default branch is master (override with -build-arg RDKIT_BRANCH=<branch name>)
ARG RDKIT_BRANCH=master
RUN git clone --branch $RDKIT_BRANCH --single-branch https://github.com/rdkit/rdkit.git

WORKDIR /rdkit
ENV RDBASE=/rdkit
ENV LD_LIBRARY_PATH=$RDBASE/lib
ENV PYTHONPATH=$RDBASE
RUN mkdir build
WORKDIR build

#disabling the test allows us to avoid the libboost-all-dev package (and might help speed up builds)
#
RUN sed -i 's/option(RDK_BUILD_CPP_TESTS "build the c++ tests (disabing can speed up builds" ON)/option(RDK_BUILD_CPP_TESTS "build the c++ tests (disabing can speed up builds" OFF)/' ../CMakeLists.txt
RUN sed -i 's/option(RDK_BUILD_MAEPARSER_SUPPORT "build the rdkit MAE parser wrapper" ON )/option(RDK_BUILD_MAEPARSER_SUPPORT "build the rdkit MAE parser wrapper" OFF )/' ../CMakeLists.txt

RUN cmake ..
RUN make -j 8
RUN make install
RUN python3 -c "from rdkit import Chem; m = Chem.MolFromSmiles('Cc1ccccc1');print(m);print(m.GetNumAtoms())"

#done building rdkit - now collect the required rdkit files (generated by make install)
WORKDIR /rdkit
RUN tar zcvf /rdkit-compiled.tgz lib rdkit

#we can now rebuild the image and only copy the relevant artifacts from the build (to save space)
FROM ubuntu:20.04
WORKDIR /rdkit
COPY --from=builder /rdkit-compiled.tgz .
RUN tar zxvf rdkit-compiled.tgz
RUN rm -f rdkit-compiled.tgz

ENV RDBASE=/rdkit
ENV LD_LIBRARY_PATH=$RDBASE/lib
ENV PYTHONPATH=$RDBASE

#REINSTALL DEPS
RUN apt update && apt upgrade -y; exit 0
RUN apt install -y wget vim unzip python3 python3-numpy libfreetype6
RUN apt install -y libboost-iostreams1.71.0 libboost-system1.71.0 libboost-python1.71.0 libboost-serialization1.71.0 libboost-program-options1.71.0
RUN python3 -c "import rdkit; print(rdkit.__version__)"
RUN python3 -c "import rdkit; print(rdkit.__version__)" > /rdkit/rdkit-version.txt
RUN python3 -c "from rdkit import Chem; m = Chem.MolFromSmiles('Cc1ccccc1');print(m);print(m.GetNumAtoms())"
COPY test-rdkit.sh /rdkit/test-rdkit.sh
RUN chmod 555 /rdkit/test-rdkit.sh
