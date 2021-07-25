context("test navbarServer")

testServer(navbarServer, args = list(
  datastore = reactiveValues(
    nav_option = character(),
    vessel = character(),
    texture = character()
  )
), {
  # validate cargo button click returns 'Cargo' as option to parent mod
  session$setInputs(cargo = 1)
  expect_equal(datastore$nav_option, "Cargo")
})
