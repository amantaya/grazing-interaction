FROM rocker/verse:4.0.5

LABEL org.opencontainers.image.authors="aantaya@arizona.edu"

# install the dependencies for the "units" package
RUN apt-get update && apt-get install -y \
      libudunits2-dev

# install all required R packages
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "install.packages('pacman', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('usethis', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('credentials', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('ggthemes', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('jpeg', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('viridis', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('scales', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('knitr', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('lubridate', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('magrittr', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('stringi', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('rio', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('openxlsx', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('Rcpp', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('ggpubr', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('rstatix', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('XML', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('tictoc', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('openssl', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('RPushbullet', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('ggfittext', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('ggsci', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('effsize', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('pwr', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('hms', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('styler', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('lintr', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "remotes::install_version('formatR', version = 1.12, repos = 'https://cran.r-project.org/')"
RUN R -e "install.packages('RColorBrewer', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('dlookr', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('rmarkdown', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('dplyr', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('tidyr', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('units', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "remotes::install_version('flextable', version = '0.7.2', repos = 'https://cran.r-project.org/')"
RUN R -e "remotes::install_version('rticles', version = '0.23', repos = 'https://cran.r-project.org/')"
RUN R -e "remotes::install_version('bookdown', version = '0.27', repos = 'https://cran.r-project.org/')"
RUN R -e "remotes::install_version('officedown', version = '0.2.4', repos = 'https://cran.r-project.org/')"

# copy my R Studio preferences into the .config folder
COPY --chown=rstudio .rstudio/rstudio/rstudio-prefs.json home/rstudio/.config/rstudio/rstudio-prefs.json
