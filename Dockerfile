FROM rocker/shiny-verse:3.6.0

# install other packages
RUN install2.r data.table

#RUN Rscript -e "devtools::install_github('')"

# net cat if needed for testing
#RUN apt-get update && apt-get -y install netcat && apt-get clean

# add user and make sure her stuff is writable 
# whichever userid is given at runtime
RUN adduser --disabled-password --gid 0 --gecos "SHINY user" shiny
USER shiny
RUN chown shiny:root /home/shiny && chmod -R 0775 /home/shiny
ENV HOME /home/shiny

RUN mkdir -m 0775 /home/shiny/apps
RUN mkdir -m 0775 /home/shiny/logs
RUN mkdir -m 0775 /home/shiny/bookmark
# RUN  cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/
COPY  shiny_app/ /home/shiny/apps/


# add changelog file t
COPY ./CHANGELOG.md /home/shiny/

EXPOSE 3838


# run the server
CMD ["R", "-e", "shiny::runApp('/home/shiny/apps/', port=3838,host='0.0.0.0')"]
