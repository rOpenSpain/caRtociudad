test_that("cartociudad_geocode returns the location of a full address", {
  result <- cartociudad_geocode("plaza de cascorro 11, 28005 madrid")

  expect_true(nrow(result) > 0)
})

test_that("get_cartociudad_map returns a map for a valid location", {
  map <- cartociudad_get_map(c(40.41137, -3.707168), 1)

  expect_s3_class(map, "raster")
  expect_s3_class(map, "ggmap")
})

test_that("get_cartociudad_location_info returns info for a valid location", {
  result <- cartociudad_get_location_info(40.473219, -3.7227241)

  expect_true(!is.null(result$seccion))
  expect_true(!is.null(result$distrito))
  expect_true(!is.null(result$provincia))
  expect_true(!is.null(result$municipio))
  expect_true(!is.null(result$ref.catastral))
  expect_true(!is.null(result$url.ref.catastral))
  expect_true(!is.null(result$tipo))
  expect_true(!is.null(result$tipo.via))
  expect_true(!is.null(result$nombre.via))
  expect_true(!is.null(result$num.via))
  expect_true(!is.null(result$num.via.id))
  expect_true(!is.null(result$cod.postal))
})

test_that("cartociudad_reverse_geocode returns an address for a valid location", {
  result <- cartociudad_reverse_geocode(40.473219, -3.7227241)

  expect_true(!is.null(result$tipo))
  expect_true(!is.null(result$tipo.via))
  expect_true(!is.null(result$nombre.via))
  expect_true(!is.null(result$num.via))
  expect_true(!is.null(result$num.via.id))
  expect_true(!is.null(result$municipio))
  expect_true(!is.null(result$provincia))
  expect_true(!is.null(result$cod.postal))
})

test_that("get_cartociudad_user_agent returns the package name and github repo url", {
  ua <- get_cartociudad_user_agent()
  result <- httr::GET("http://eu.httpbin.org/user-agent", ua)
  httr::stop_for_status(result)

  user.agent <- httr::content(result)$"user-agent"
  expect_true(length(grep("caRtociudad/[0-9.]+", user.agent)) == 1)
  expect_true(length(grep("github.com/rOpenSpain/caRtociudad", user.agent)) == 1)
})

test_that("cartociudad_get_area with valid parameters returns a polygon", {
  result <- cartociudad_get_area(40.3930144, -3.6596683, 500)

  expect_true(nrow(result) > 2)
})
