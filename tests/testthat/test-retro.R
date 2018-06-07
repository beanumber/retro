context("retro")

test_that("retro works", {
  if (require(RMySQL) && mysqlHasDefault()) {
    my_dir = "~/dumps/retro/"
    if (dir.exists(my_dir)) {
      db <- src_mysql_cnf("retrosheet")
      retro <- etl("retro", db = db, dir = "~/dumps/retro/")
      expect_s3_class(retro, "src_sql")
    }
  }
})
