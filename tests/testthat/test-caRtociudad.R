context("requests")

test_that("cartociudad_geocode returns the location of a full address", {
  result <- cartociudad_geocode("plaza de cascorro 11, 28005 madrid")

  expect_that(nrow(result) > 0, is_true())
})

test_that("get_cartociudadmap returns a map for a valid location", {
  map <- get_cartociudadmap(c(40.41137, -3.707168), 1)

  expect_that(map, is_a("raster"))
  expect_that(map, is_a("ggmap"))
})

test_that("get_cartociudad_location_info returns info for a valid location", {
  result <- get_cartociudad_location_info(40.473219, -3.7227241)

  expect_that(!is.null(result$seccion),           is_true())
  expect_that(!is.null(result$distrito),          is_true())
  expect_that(!is.null(result$provincia),         is_true())
  expect_that(!is.null(result$municipio),         is_true())
  expect_that(!is.null(result$ref.catastral),     is_true())
  expect_that(!is.null(result$url.ref.catastral), is_true())
  expect_that(!is.null(result$tipo),              is_true())
  expect_that(!is.null(result$tipo.via),          is_true())
  expect_that(!is.null(result$nombre.via),        is_true())
  expect_that(!is.null(result$num.via),           is_true())
  expect_that(!is.null(result$num.via.id),        is_true())
  expect_that(!is.null(result$cod.postal),        is_true())
})

test_that("cartociudad_reverse_geocode returns an address for a valid location", {
  result <- cartociudad_reverse_geocode(40.473219, -3.7227241)

  expect_that(!is.null(result$tipo),       is_true())
  expect_that(!is.null(result$tipo.via),   is_true())
  expect_that(!is.null(result$nombre.via), is_true())
  expect_that(!is.null(result$num.via),    is_true())
  expect_that(!is.null(result$num.via.id), is_true())
  expect_that(!is.null(result$municipio),  is_true())
  expect_that(!is.null(result$provincia),  is_true())
  expect_that(!is.null(result$cod.postal), is_true())
})

test_that("get_cartociudad_user_agent returns the package name and github repo url", {
  ua <- get_cartociudad_user_agent()
  result <- httr::GET("http://httpbin.org/user-agent", ua)
  httr::stop_for_status(result)

  user.agent <- httr::content(result)$"user-agent"
  expect_that(length(grep("caRtociudad/[0-9.]+",               user.agent)) == 1, is_true())
  expect_that(length(grep("github.com/rOpenSpain/caRtociudad", user.agent)) == 1, is_true())
})

test_that("get_cartociudad_area with valid parameters returns a polygon", {
  result <- get_cartociudad_area(40.3930144, -3.6596683, 500)

  expect_that(nrow(result) > 2, is_true())
})
