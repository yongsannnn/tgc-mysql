const express = require("express");
const hbs = require("hbs");
const wax = require("wax-on");
const mysql = require("mysql2/promise");

let app = express();
app.set("view engine", "hbs");
app.use(express.static("public"));
wax.on(hbs.handlebars);
wax.setLayoutPath("./views/layouts");

app.use(express.urlencoded({ extended: false }));

require("handlebars-helpers")({
  handlebars: hbs.handlebars,
});

// ROUTES BEGIN HERE

app.listen(3000, () => {
  console.log("Server started");
});