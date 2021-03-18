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

async function main() {
    // create a sql connection
    const connection = await mysql.createConnection({
        // host is usually the web address of the db or more commonly an ip address
        "host": "localhost",
        "user" : "root",
        "database" : "sakila" 
    });

    // let query = "SELECT * FROM actor";
    // // LINE BELOW IS ARRAY DESTRUCTURING
    // let [actors] = await connection.execute("SELECT * FROM actor");
    // // instead of 
    // // let response. await connection.execute("SELECT * FROM actor")
    // // let actors = response[0];
    // for (let a of actors){
    //     console.log(a)
    // }
    // console.log(actors.toJSON())

    app.get("/actors", async (req,res)=>{
        let [actors] = await connection.execute("SELECT * FROM actor");
        res.render("actors",{
            "actors": actors
        })
    })
}

main();

app.listen(3000, () => {
  console.log("Server started");
});