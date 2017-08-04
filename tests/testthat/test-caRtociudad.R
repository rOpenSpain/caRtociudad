context("requests")

test_that("cartociudad_geocode & cartociudad_reverse_geocode return valid locations", {
  res_geo     <- cartociudad_geocode("plaza de cascorro 11, 28005 madrid")
  res_inv_geo <- cartociudad_reverse_geocode(res_geo$lat, res_geo$lng)

  expect_false(all(sapply(res_geo, is.null)))
  expect_false(all(sapply(res_inv_geo, is.null)))
  expect_true(nrow(res_geo) > 0)
  expect_true(nrow(res_inv_geo) > 0)

  expect_equal(res_geo$state, "1")
  expect_equal(res_geo$lat, 40.40988, tolerance = 1e-06)
  expect_equal(res_geo$lng, -3.707076, tolerance = 1e-06)

  expect_equal(res_inv_geo$num.via, "11")
  expect_equal(res_inv_geo$cod.postal, "28005")
  expect_equal(res_inv_geo$municipio, "MADRID")
  expect_equal(res_inv_geo$tipo, "portal")

  expect_equal(res_geo$lat, as.numeric(res_inv_geo$lat))
  expect_equal(res_geo$lng, as.numeric(res_inv_geo$lng))
})

test_that("Geocoding and reverse geocoding wrong addresses", {
  addresses   <- c(
    "plaza de cascorro 9000, madrid",
    "plaza de cascorro 9001, madrid",
    "a7 3000",
    "plaza doctor balmis 2, alicante",
    "calle inventadisima 1, valencia"
  )
  res_geo     <- cartociudad_geocode(addresses)
  res_inv_geo <- cartociudad_reverse_geocode(res_geo$lat[-5], res_geo$lng[-5])

  expect_true(nrow(res_geo) == length(addresses))
  expect_true(nrow(res_inv_geo) == length(addresses[-5]))

  expect_equal(res_geo$state, c("2", "3", "4", "5", "10"))

  expect_equal(res_geo$address[1:3], res_inv_geo$nombre.via[1:3])

  expect_warning(cartociudad_reverse_geocode(res_geo$lat[5], res_geo$lng[5]))
})

test_that("get_cartociudadmap returns a map for a valid location", {
  map <- get_cartociudadmap(c(40.41137, -3.707168), 1)

  expect_is(map, c("raster", "ggmap"))
})

test_that("get_cartociudad_location_info returns info for a valid location", {
  result <- get_cartociudad_location_info(40.473219, -3.7227241)

  expect_false(all(sapply(result, is.null)))
})

test_that("get_cartociudad_user_agent returns the package name and github repo url", {
  ua <- get_cartociudad_user_agent()
  result <- httr::GET("http://httpbin.org/user-agent", ua)
  httr::stop_for_status(result)

  user.agent <- httr::content(result)$"user-agent"
  expect_length(grep("caRtociudad/[0-9.]+",         user.agent), 1)
  expect_length(grep("github.com/cjgb/caRtociudad", user.agent), 1)
})

test_that("get_cartociudad_area with valid parameters returns a polygon", {
  result <- get_cartociudad_area(40.3930144, -3.6596683, 500)

  expect_gt(nrow(result), 2)
})
