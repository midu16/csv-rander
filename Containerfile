FROM docker.io/library/centos:7
MAINTAINER midu@redhat.com
#
ENV PRE_GA_INDEX="quay.io/midu/olm/redhat-operator-index"
ENV PRE_GA_TAG="v4.13"
# upgrading the image and installing packages to the container
RUN yum upgrade -y && yum upgrade -y && yum install epel-release -y && yum install jq -y && yum install coreutils -y
# trim a little
RUN yum autoremove -y
# creating the admin user
RUN useradd -ms /bin/bash admin
# adding the admin user to 'sudo' group
RUN usermod -a -G root admin
# sudoers.d/admin creation
RUN mkdir -p /etc/sudoers.d/ && echo "admin ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/admin
RUN chmod 044 /etc/sudoers.d/admin
# switching to admin user
USER admin
# switching to admin homedirectory
WORKDIR /home/admin
# creating the workdirectory
RUN mkdir -p /home/admin/render-workdir && mkdir -p /home/admin/.docker
# creating /home/admin/.docker
VOLUME /home/admin/.docker
# switching to the workdirectory
WORKDIR /home/admin/render-workdir
# downloading the linux-adm64-opm binary
RUN curl -O -L https://github.com/operator-framework/operator-registry/releases/download/v1.26.2/linux-amd64-opm
# making sure that linux-amd64-opm is executable
RUN chmod a+x linux-amd64-opm
# copy the translate.jq
COPY translate.jq /home/admin/render-workdir/translate.jq
#
COPY render.sh /home/admin/render-workdir/render.sh
# making sure that render.sh is executable
RUN ls -l /home/admin/render-workdir/

CMD /bin/bash -c '/home/admin/render-workdir/render.sh ${PRE_GA_INDEX} ${PRE_GA_TAG} | tee /home/admin/.docker/redhat-operator-index.csv ; /bin/bash'