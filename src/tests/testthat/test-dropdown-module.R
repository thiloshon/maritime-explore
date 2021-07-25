context("test dropdownServer")

testServer(dropdownServer,
           args = list(
             ships = data.frame(
               SHIPNAME = c("A", "B", "C"),
               SHIP_ID = c(1, 2, 3),
               ship_type = c("Cargo", "Fishing", "Cargo")
             ),
             datastore = reactiveValues(
               nav_option = character(),
               vessel = character(),
               texture = character()
             )
           ),
           {
             # validate vessel dropdown change returns 'vessel' to parent mod
             session$setInputs(vessel = 1960)
             expect_equal(datastore$vessel(), 1960)
           })
