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

    app.get("/actors/create", async (req,res)=>{

        res.render("actor_create");
    })

    app.post("/actors/create", async (req,res)=>{
        let {first_name, last_name}= req.body;
        // instead of
        // let first_name = req.body.first_name
        // let last_name = req.body.last_name

        // WRONG METHOD, using TEMPLATE LITERALS are vulnerable to SQL Injection
        // let query = `insert into actor (first_name,last_name) VALUES ("${first_name}","${last_name}" )`
        
        // Use PREPARED STATEMENTS to insert
        // SQL will take it as literal data, it will not run it as a CODE
        // If the person insert in SQL code, it will still take it literally
        let query = `insert into actor (first_name,last_name) VALUES (?,?)`
        await connection.execute(query,[first_name, last_name]);
        
        await connection.execute(query)

        res.redirect("/actors")
    })
}

main();

app.listen(3000, () => {
  console.log("Server started");
});