context("retro")

test_that("retro works", {
  if (require(RMySQL) && RMySQL::mysqlHasDefault()) {
    my_dir = "~/dumps/retro/"
    db <- src_mysql_cnf("retrosheet")
    if (dir.exists(my_dir)) {
      retro <- etl("retro", db = db, dir = "~/dumps/retro/")
    } else {
      retro <- etl("retro")
      retro %>%
        etl_update(season = 1950)
    }
    expect_s3_class(retro, "src_sql")
  }
})
