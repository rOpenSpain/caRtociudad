context("requests")

test_that("cartociudad_geocode returns the location of a full address", {
  result <- cartociudad_geocode("plaza de cascorro 11, 28005 madrid")
  
  expect_that(nrow(result) > 0, is_true())
})

test_that("cartociudad_geocode returns the location of address chunks", {
  result <- cartociudad_geocode(road_type = "plaza", road_name = "cascorro",
                                zip = "28012", municipality = "madrid",
                                province = "madrid")
  
  expect_that(nrow(result) > 0, is_true())
})

test_that("get_cartociudadmap returns a map for a valid location", {
  map <- get_cartociudadmap(c(40.41137, -3.707168), 1)
  
  expect_that(map, is_a("raster"))
  expect_that(map, is_a("ggmap"))
})

test_that("get_cartociudad_location_info returns info for a valid location", {
  result <- get_cartociudad_location_info(40.473219, -3.7227241, year = 2015)
  
  expect_that(!is.null(result$seccion),           is_true())
  expect_that(!is.null(result$distrito),          is_true())
  expect_that(!is.null(result$provincia),         is_true())
  expect_that(!is.null(result$municipio),         is_true())
  expect_that(!is.null(result$ref.catastral),     is_true())
  expect_that(!is.null(result$url.ref.catastral), is_true())
})

