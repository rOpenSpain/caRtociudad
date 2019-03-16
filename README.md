# caRtociudad

[![Build Status](https://travis-ci.org/rOpenSpain/caRtociudad.svg?branch=master)](https://travis-ci.org/rOpenSpain/caRtociudad)

R package to query [Cartociudad](http://www.cartociudad.es) API. The API is documented [here](http://www.cartociudad.es/recursos/Documentacion_tecnica/CARTOCIUDAD_ServiciosWeb.pdf).

## Installation

```
library(devtools)
install_github("rOpenSpain/caRtociudad")
```

## Geocoding

```
# using full address
my.address <- cartociudad_geocode("plaza de cascorro 11, 28005 madrid")
print(my.address)
```

## Reverse geocoding

Function `cartociudad_reverse_geocode` returns the address details of a location.

```
cartociudad_reverse_geocode(40.45332, -3.69442)
```

## Mapping

Function `get_cartociudadmap` downloads static maps from Cartociudad servers and tries to imitate the behaviour of `ggmap::get_googlemap`. The query below returns a map that can be then plotted using `ggmap` after possibly adding other features (points, segments, paths, etc.). The second parameter in the call to `get_cartociudadmap` indicates that the map will cover an area of an approximate radius of 1 km.

```
soria <- cartociudad_geocode("ayuntamiento soria")
soria_map <- cartociudad_get_map(c(soria$lat, soria$lng), 1)
ggmap::ggmap(soria_map)
```

Cartociudad maps can include different kinds of layers, such as postal codes or cadastral references. The full list of available layers can be consulted in the [API reference manual](http://www.cartociudad.es/recursos/Documentacion_tecnica/CARTOCIUDAD_ServiciosWeb.pdf).

## Area

Function `get_cartociudad_area` calculates the area given a point and a radius in meters. E.g.,

```
library(ggplot2)
library(ggmap)

vallecas.lat <- 40.3930144
vallecas.lon <- -3.6596683
map <- cartociudad_get_map(c(vallecas.lat, vallecas.lon), 1)
polygon <- cartociudad_get_area(vallecas.lat, vallecas.lon, 500)
ggmap(map) +
  geom_polygon(data = polygon, aes(x = longitude, y = latitude), colour = "red", fill = NA)
```

draws a polygon around the given center in a map.

## Location info

Function `get_cartociudad_location_info` provides administrative information on a point indicated by its coordinates. E.g.,

```
get_cartociudad_location_info(40.473219, -3.7227241)
```
indicates the reverse geocoding details, censal section, censal district, cadastral information and the url to the spanish cadastre website associated to the point.

## Data usage license

The data returned by this package is provided by IGN web services and implies the user's acceptance of a [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/) license. More info available [here](http://www.ign.es/web/resources/docs/IGNCnig/FOOT-Condiciones_Uso_eng.pdf).

## TODO

Add extra API functionalities to the package.

## Help wanted!

If you want to help extend the package, do write to the maintainer and submit your code. It will be reviewed you will be added to the list of authors.
