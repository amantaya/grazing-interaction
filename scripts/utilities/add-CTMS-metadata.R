# loading the library and other important packages
library("XML")
library("methods")

# the contents of sample.xml are parsed
data <- xmlParse(file = "sample.xml")

metadata <- xmlParse(file = "metadata/White-Mountains-CTMS.xml")

print(data)

print(metadata)
