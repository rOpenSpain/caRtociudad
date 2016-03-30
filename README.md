# caRtociudad

R package to query [Cartociudad](http://www.cartociudad.es) API. The API is documented [here](http://www.cartociudad.es/recursos/Documentacion_tecnica/CARTOCIUDAD_ServiciosWeb.pdf).

## Installation

```
library(devtools)
install_github("cjgb/caRtociudad")
```

## Geocoding

```
# using full address
my.address <- cartociudad_geocode("plaza de cascorro 11, 28005 madrid")
print(my.address)

# using address chunks
my.address <- cartociudad_geocode(road_type = "plaza", road_name = "cascorro",
    zip = "28012", municipality = "madrid", province = "madrid")
print(my.address)
```

## TODO

Add extra API functionalities to the package.

## Help wanted!

If you want to help extend the package, do write to the maintainer and submit your code. It will be reviewed you will be added to the list of authors.
