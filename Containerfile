FROM docker.io/library/centos:7
MAINTAINER midu@redhat.com

# upgrading the image and installing packages to the container
RUN yum upgrade -y && yum upgrade -y && yum install epel-release -y && yum install jq -y 
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
RUN mkdir -p /home/admin/render-workdir
# switching to the workdirectory
WORKDIR /home/admin/render-workdir
# downloading the linux-adm64-opm binary
RUN curl -O -L https://github.com/operator-framework/operator-registry/releases/download/v1.26.2/linux-amd64-opm
# making sure that linux-amd64-opm is executable
RUN chmod a+x linux-amd64-opm
# 
ENV PRE_GA_INDEX=quay.io/midu/olm/redhat-operator-index:v4.13
# creating the render index js 
RUN  ./linux-amd64-opm render ${PRE_GA_INDEX} > render.json
# copy the translate.jq 
COPY translate.jq /home/admin/render-workdir/translate.jq
# 
RUN jq -r -f translate.jq render.json

CMD ["/bin/bash"]
