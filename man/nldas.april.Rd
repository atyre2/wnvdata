% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wnv_data_docs.R
\docType{data}
\name{nldas.april}
\alias{nldas.april}
\title{NLDAS April Soil Moisture Data}
\format{
An object of class \code{data.frame} with 68376 rows and 6 columns.
}
\source{
\url{https://disc.gsfc.nasa.gov/}
}
\usage{
nldas.april
}
\description{
Soil moisture data were downloaded from NLDAS NOAH and read into R.
This uses the SOILM variable, and only the average (corresponding to 100 cm value)
Only data from the county centroid were used. However this may not be representative of
the soil moisture in each county, and a county average may perform better
(empirically there was no advantage to using a county average over a county
centroid in Keyel et al. 2019)
}
\details{
I went to https://disc.gsfc.nasa.gov/ and searched for NLDAS
This led me to a page with a list of NLDAS datasets here:
https://disc.gsfc.nasa.gov/datasets?keywords=NLDAS&page=1
I selected the NLDAS NOAH monthly data set (NOTE that other options exist
and have been used in other studies)
https://disc.gsfc.nasa.gov/datasets/NLDAS_NOAH0125_M_002/summary?keywords=NLDAS
I selected Subset / Get Data
Selected the SOILM variable (Soil moisture content (kg/m^2))
I only downloaded data from 2015 - 2020, as I had already downloaded NLDAS NOAH
data from Park Williams' website. Data were downloaded in netcdf format.
I clicked Get data, had 64 links. Data were downloaded with wget.exe
using the batch file NLDAS_wget_2015_2020.bat and the link text file
subset_NLDAS_NOAH0125_M_002_20200422_155125*.txt. NOTE that in the
.bat file you must replace "USERNAME" with your username and "REDACTED" with
your password, and change the extension from .txt to .bat. There were
two text files, because not all files processed the first time through
for unknown reasons. Data from April 2020 were downloaded
in a similar manner to the above, except without wget, as there was only
one file to download and process. See nldas.april.R for remaining
processing steps.
}
\keyword{datasets}
