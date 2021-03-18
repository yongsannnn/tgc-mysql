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
        "user": "root",
        "database": "sakila"
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

    app.get("/actors", async (req, res) => {
        let [actors] = await connection.execute("SELECT * FROM actor");
        res.render("actors", {
            "actors": actors
        })
    })

    app.get("/actors/create", async (req, res) => {

        res.render("actor_create");
    })

    app.post("/actors/create", async (req, res) => {
        let { first_name, last_name } = req.body;
        // instead of
        // let first_name = req.body.first_name
        // let last_name = req.body.last_name

        // WRONG METHOD, using TEMPLATE LITERALS are vulnerable to SQL Injection
        // let query = `insert into actor (first_name,last_name) VALUES ("${first_name}","${last_name}" )`

        // Use PREPARED STATEMENTS to insert
        // SQL will take it as literal data, it will not run it as a CODE
        // If the person insert in SQL code, it will still take it literally
        let query = `insert into actor (first_name,last_name) VALUES (?,?)`
        await connection.execute(query, [first_name, last_name]);


        res.redirect("/actors")
    })

    app.get("/actors/:actor_id/update", async (req, res) => {
        // 1. retrieve the actor that we want to update
        let query = "SELECT * from actor WHERE actor_id = ?";
        let [actors] = await connection.execute(query, [req.params.actor_id]);
        let actor = actors[0];

        // 2. render out the form with the actor's data prefilled in
        res.render("actor_update", {
            "actor": actor
        })

    })

    app.post("/actors/:actor_id/update", async (req, res) => {
        // 1. read in the new first name and last name
        let { first_name, last_name } = req.body

        let query = "UPDATE actor set first_name=?, last_name=? WHERE actor_id=?"
        await connection.execute(query, [first_name, last_name, req.params.actor_id]);
        res.redirect("/actors")
    })


    app.get("/actors/:actor_id/delete", async (req, res) => {
        // 1. retrieve the actor that we want to update
        let query = "SELECT * from actor WHERE actor_id = ?";
        let [actors] = await connection.execute(query, [req.params.actor_id]);
        let actor = actors[0];

        res.render("actor_delete", {
            "actor": actor
        })
    })

    app.post("/actors/:actor_id/delete", async (req, res) => {
        let query = "DELETE FROM actor WHERE actor_id = ?"
        await connection.execute(query, [req.params.actor_id]);
        res.redirect("/actors");
    })



    // Film Create
    app.get("/films/create", async (req, res) => {
        let [languages] = await connection.execute("SELECT * from language");
        let [actors] = await connection.execute("SELECT * from actor")
        res.render("film_create", {
            "languages": languages,
            "actors": actors
        })
    })

    app.post("/films/create", async (req, res) => {
        try {
            await connection.beginTransaction();
            let query = `INSERT INTO film(title, description, release_year, original_language_id,
            language_id, rental_duration, rental_rate, length, replacement_cost) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`;

            let [results] = await connection.execute(query, [
                req.body.title,
                req.body.description,
                req.body.release_year,
                req.body.original_language_id,
                req.body.language_id,
                req.body.rental_duration,
                req.body.rental_rate,
                req.body.length,
                req.body.replacement_cost
            ])

            // add in actors
            if (req.body.actors) {
                let actors = Array.isArray(req.body.actors) ? req.body.actors : [req.body.actors]
                for (let a of actors) {
                    connection.execute("INSERT INTO film_actor (actor_id, film_id) VALUES (?,?)", [a, results.insertId])
                }

            }

            connection.commit();
            res.send("Film added")

        } catch (e) {
            console.log(e);
            connection.rollback();
            res.send("Error!!!!")
        }

    })

    app.get("/films/:film_id/update", async (req, res) => {
        // fetch the movie
        const query = "SELECT * from film WHERE film_id = ?"

        let [films] = await connection.execute(query, [req.params.film_id])
        let film = films[0]
        // get all actors
        const [actors] = await connection.execute("SELECT * from actor")
        // get all actors who acted in this film
        const [actorsInFilm] = await connection.execute("Select actor_id from film_actor where film_id = ?", [req.params.film_id])

        // Map to get the index
        const actorIDsInFilm = actorsInFilm.map(a => a.actor_id);

        // fetch all the languages
        let [languages] = await connection.execute("SELECT * from language");

        res.render("film_update", {
            "film": film,
            "languages": languages,
            "actors": actors,
            "actorsInFilm": actorIDsInFilm

        })
    })

    app.post("/films/:film_id/update", async (req, res) => {
        try {
            connection.beginTransaction();
            let query = `UPDATE film SET title=?, description=?, release_year=?, original_language_id=?,
            language_id=?, rental_duration=?, rental_rate=?, length=?, replacement_cost=? WHERE film_id=?`;
            await connection.execute(query, [
                req.body.title,
                req.body.description,
                req.body.release_year,
                req.body.original_language_id,
                req.body.language_id,
                req.body.rental_duration,
                req.body.rental_rate,
                req.body.length,
                req.body.replacement_cost,
                req.params.film_id
            ])

            // 1. DELETE All the actors from the table 
            await connection.execute("DELETE FROM film_actor where film_id = ?", [
                req.params.film_id
            ]);
            // 2. Add all the actors selected
            if (req.body.actors) {

                let actors = Array.isArray(req.body.actors) ? req.body.actors : [req.body.actors];
                for (let a of actors) {
                    connection.execute("INSERT INTO film_actor (actor_id, film_id) VALUES (?, ?)", [a, req.params.film_id])
                }
            }
            res.send("Film updated")
            connection.commit();
        } catch (e) {
            console.log(e);
            connection.rollback();
        }

    })


    app.get("/films", async (req, res) => {
        // base query
        let query = "SELECT * from film JOIN language ON film.language_id = language.language_id WHERE 1"
        
        let bindings = [];

        // add in search criteria
        if(req.query.title) {
            query += " AND title LIKE ? ";
            bindings.push("%"+req.query.title+"%");
        }

        if(req.query.release_year){
            query += " AND release_year = ?";
            bindings.push(req.query.release_year)
        }
        
        const [films] = await connection.execute(query, bindings)

        res.render("film", {
            films, 
            "searchParams": req.query
        })
    })
}

main();

app.listen(3000, () => {
    console.log("Server started");
});