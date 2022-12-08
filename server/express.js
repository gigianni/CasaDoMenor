"use strict";

const EXPRESS = require('express');
const MY_SQL = require('mysql');
const BODY_PARSER = require('body-parser');
const LOGGER = require('morgan');
var CORS = require('cors');
//const ASYNC = require('async');
const FS = require('fs');
const COOKIE_PARSER = require('cookie-parser');
const BCRYPT = require('bcryptjs');
const JWT = require('jsonwebtoken');
const HTTPS = require('https');
const NODEMAILER = require('nodemailer');
//const HTTP = require('http');

const PRIVATE_KEY = FS.readFileSync('./keys/privateKey.key', 'utf-8');
const CERTIFICATE = FS.readFileSync('./keys/certificate.crt', 'utf-8');
const CREDENTIALS = { "key": PRIVATE_KEY, "cert": CERTIFICATE };
const TIMEOUT_TOKEN = 3600; //secondi
const TIMEOUT_COOKIE = TIMEOUT_TOKEN * 1000; //millisecondi
const SALT_VALUE = 12;
const PORT = 1337;


const APP = EXPRESS();
APP.use(BODY_PARSER.json());
APP.use(BODY_PARSER.urlencoded({ extended: true }));
APP.use(LOGGER('dev'));
APP.use(CORS({
    'Access-Control-Expose-Headers': 'Access-Control-*',
    'Access-Control-Allow-Headers': 'Access-Control-*, Origin, X-Requested-With, Content-Type, Accept, Set-Cookie',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS, HEAD',
    origin: "http://localhost:8080",
    credentials: true,
    'Allow': 'GET, POST, PUT, DELETE, OPTIONS, HEAD',
    'Access-Control-Allow-Credentials': 'true'
}));


const TRANSPORTER = NODEMAILER.createTransport({
    service: 'gmail',
    auth: {
        user: '*****@***.***',
        pass: '********'
    }
});


const POOL = MY_SQL.createPool({
    connectionLimit: 10,
    host: 'localhost',
    user: 'express',
    password: '********',
    database: 'cdm',
    multipleStatements: true
});

APP.use(COOKIE_PARSER());
/*
APP.use('/', function (request, response, next) {
    if (request.originalUrl == '/api/login' || request.originalUrl == '/api/logout')
        next();
    else {
        let token = request.cookies.token;
        if (token == undefined) //andiamo per tentativi -> o NULL o ''
            next(new Error('undefined token'));
        else
            JWT.verify(token, PRIVATE_KEY, function (err, payload) {
                if (err)
                    next(err);
                else {
                    let exp = Math.floor(Date.now() / 1000) + TIMEOUT;
                    payload = { ...payload, "exp": exp };
                    response.cookie('token', creaToken(payload), {
                        "maxAge": TIMEOUT,
                        "path": "/",
                        "httpOnly": true,
                        "secure": true
                    });
                    req.token = payload;
                    next();
                }
            });
    }
});*/

APP.use(EXPRESS.static('./static'));

APP.use('/', function (request, response, next) {
    if (request.originalUrl == '/login' || request.originalUrl == '/logout' || request.originalUrl == '/passwordReset')
        next();
    else {
        let token = request.cookies.token;
        if (!token)
            next(new Error('undefined token'));
        else
            JWT.verify(token, PRIVATE_KEY, function (err, payload) {
                if (err)
                    next(err);
                else {
                    let exp = Math.floor(Date.now() / 1000) + TIMEOUT_TOKEN;
                    payload = { ...payload, "exp": exp };
                    response.cookie('token', creaToken(payload), {
                        "maxAge": TIMEOUT_COOKIE,
                        "path": "/",
                        "httpOnly": true,
                        "secure": false
                    });
                    request.token = payload;
                    console.log("113 user: " + payload.username);
                    next();
                }
            });
    }
});

APP.use("/token", function (request, response, next) {
    response.send('"OK"');
});

APP.post('/login', function (request, response, next) {
    let user = request.body.username;
    POOL.query(`SELECT * FROM users WHERE BINARY username='${user}'`, function (err, rows, fields) {
        if (!err) {
            let psw = request.body.password;
            if (rows.length == 0)
                response.status(404).send('"NOK"');
            else {
                BCRYPT.compare(psw, rows[0]['password'], function (err, result) {
                    if (!err)
                        if (result) {
                            response.cookie('token', creaToken(rows[0]), {
                                "maxAge": TIMEOUT_COOKIE,
                                "path": "/",
                                "httpOnly": true,
                                "secure": false
                            });
                            response.send('"OK"');
                        }
                        else {
                            response.status(401).send('"NOK"');
                        }
                    else
                        next(err);
                });
            }
        }
        else
            next(err);
    });
});

APP.get('/tables', function (request, response, next) {
    POOL.query('SHOW TABLES;', function (err, rows, fields) {
        if (!err)
            response.send(rows);
        else
            next(err);
    });
});

APP.use('/api/', function (request, response, next) {
    console.log("Body parameters:");
    console.log(request.body);
    console.log("Get parameters:");
    console.log(request.query);
    next();
});

//#region PRIVATE_ACCOUNTS
APP.route('/api/private_accounts')
    .post(function (request, response, next) {
        const jsonDati = request.body;
        jsonDati["name"] = jsonDati["name"].toString().trim().toUpperCase();
        jsonDati["description"] = jsonDati["description"].toString().trim().toUpperCase();

        const QUERY = `INSERT INTO private_accounts (name,description)` +
            ` VALUES (${MY_SQL.escape(jsonDati["name"])},${MY_SQL.escape(jsonDati["description"])})`;

        POOL.query(QUERY, function (err, rows) {
            if (!err)
                response.status(200).send({});
            else
                next(err);
        });
    })
    .patch(function (request, response, next) {
        const jsonDati = request.body;
        jsonDati["name"] = jsonDati["name"].toString().trim().toUpperCase();
        jsonDati["description"] = jsonDati["description"].toString().trim().toUpperCase();

        const QUERY = `UPDATE private_accounts SET name=${MY_SQL.escape(jsonDati["name"])},description=${MY_SQL.escape(jsonDati["description"])} WHERE id=${MY_SQL.escape(jsonDati["id"])}`;

        DBQuery(QUERY, request, response, next);
    })
    .delete(function (request, response, next) {
        const jsonDati = request.query;
        const QUERY = `DELETE FROM private_accounts WHERE id=${MY_SQL.escape(jsonDati["id"])}`;

        DBQuery(QUERY, request, response, next);
    });
//#endregion

//#region PRIVATE_CAUSALS
APP.route('/api/private_causals')
    .post(function (request, response, next) {
        const jsonDati = request.body;
        jsonDati["name"] = jsonDati["name"].toString().trim().toUpperCase();

        const QUERY = `INSERT INTO private_causals (name) VALUES (${MY_SQL.escape(jsonDati["name"])})`;

        POOL.query(QUERY, function (err, rows) {
            if (!err)
                response.status(200).send({});
            else
                next(err);
        });
    })
    .patch(function (request, response, next) {
        const jsonDati = request.body;
        jsonDati["name"] = jsonDati["name"].toString().trim().toUpperCase();

        const QUERY = `UPDATE private_causals SET name=${MY_SQL.escape(jsonDati["name"])} WHERE id=${MY_SQL.escape(jsonDati["id"])}`;

        DBQuery(QUERY, request, response, next);
    })
    .delete(function (request, response, next) {
        const jsonDati = request.query;
        const QUERY = `DELETE FROM private_causals WHERE id=${MY_SQL.escape(jsonDati["id"])}`;

        DBQuery(QUERY, request, response, next);
    });
//#endregion

//#region PRIVATE_DONATIONS_GROUPS
APP.route('/api/private_donations_groups')
    .post(function (request, response, next) {
        const jsonDati = request.body;
        const QUERY = `INSERT INTO private_donations_groups (id_group,date_payment,date_registration,id_causal,id_account,value)` +
            ` VALUES (${MY_SQL.escape(jsonDati["id_group"])},${MY_SQL.escape(jsonDati["date_payment"])},${MY_SQL.escape(new Date())}` +
            `,${MY_SQL.escape(jsonDati["id_causal"])},${MY_SQL.escape(jsonDati["id_account"])},${MY_SQL.escape(jsonDati["value"])})`;

        POOL.query(QUERY, function (err, rows) {
            if (!err)
                response.status(200).send({});
            else
                next(err);
        });
    })
    .patch(function (request, response, next) {
        const jsonDati = request.body;
        const QUERY = `UPDATE private_donations_groups SET id_group=${MY_SQL.escape(jsonDati["id_group"])},date_payment=${MY_SQL.escape(jsonDati["date_payment"])},` +
            `date_registration=${MY_SQL.escape(jsonDati["date_registration"])},id_causal=${MY_SQL.escape(jsonDati["id_causal"])},id_account=${MY_SQL.escape(jsonDati["id_account"])},` +
            `value=${MY_SQL.escape(jsonDati["value"])} WHERE id=${MY_SQL.escape(jsonDati["id"])}`;

        DBQuery(QUERY, request, response, next);
    })
    .delete(function (request, response, next) {
        const jsonDati = request.query;
        const QUERY = `DELETE FROM private_donations_groups WHERE id=${MY_SQL.escape(jsonDati["id"])}`;

        DBQuery(QUERY, request, response, next);
    });
//#endregion

//#region PRIVATE_DONATIONS_PERSONS
APP.route('/api/private_donations_persons')
    .post(function (request, response, next) {
        const jsonDati = request.body;
        const QUERY = `INSERT INTO private_donations_persons (id_person,date_payment,date_registration,id_causal,id_account,value)` +
            ` VALUES (${MY_SQL.escape(jsonDati["id_person"])},${MY_SQL.escape(jsonDati["date_payment"])},${MY_SQL.escape(new Date())}` +
            `,${MY_SQL.escape(jsonDati["id_causal"])},${MY_SQL.escape(jsonDati["id_account"])},${MY_SQL.escape(jsonDati["value"])})`;

        POOL.query(QUERY, function (err, rows) {
            if (!err)
                response.status(200).send({});
            else
                next(err);
        });
    })
    .patch(function (request, response, next) {
        const jsonDati = request.body;
        const QUERY = `UPDATE private_donations_persons SET id_person=${MY_SQL.escape(jsonDati["id_person"])},date_payment=${MY_SQL.escape(jsonDati["date_payment"])},` +
            `date_registration=${MY_SQL.escape(jsonDati["date_registration"])},id_causal=${MY_SQL.escape(jsonDati["id_causal"])},id_account=${MY_SQL.escape(jsonDati["id_account"])},` +
            `value=${MY_SQL.escape(jsonDati["value"])} WHERE id=${MY_SQL.escape(jsonDati["id"])}`;

        DBQuery(QUERY, request, response, next);
    })
    .delete(function (request, response, next) {
        const jsonDati = request.query;
        const QUERY = `DELETE FROM private_donations_persons WHERE id=${MY_SQL.escape(jsonDati["id"])}`;

        DBQuery(QUERY, request, response, next);
    });
//#endregion

//#region PRIVATE_GROUPS
APP.route('/api/private_groups')
    .get(function (request, response, next) {
        const jsonDati = request.query;
        let QUERY = `SELECT * FROM private_groups`;
        let where = false;
        //o nome, o referenza, o entrambi o nessuno
        if (jsonDati.name != "" && jsonDati.name != null) {
            QUERY += ` WHERE name=${MY_SQL.escape(jsonDati.name)}`;
            where = true;
        }
        if (jsonDati.reference != "" & jsonDati.reference != null) {
            if (where)
                QUERY += ` AND reference=${MY_SQL.escape(jsonDati.reference)}`;
            else
                QUERY += ` WHERE reference=${MY_SQL.escape(jsonDati.reference)}`;
        }
        QUERY += ";";
        console.log(QUERY);
        POOL.query(QUERY, function (err, rows) {
            if (!err)
                response.status(200).send(rows);
            else
                next(err);
        });
    })
    .post(function (request, response, next) {
        const jsonDati = request.body;
        for (let campo in jsonDati)
            jsonDati[campo] = campo == "email" ? jsonDati[campo] : jsonDati[campo].toString().trim().toUpperCase();

        const QUERY = `INSERT INTO private_groups (name,reference,address,n_civ,loc,zip,city,province_code,country,telephone,email,magazine)` +
            ` VALUES (${MY_SQL.escape(jsonDati["name"])},${MY_SQL.escape(jsonDati["reference"])}` +
            `,${MY_SQL.escape(jsonDati["address"])},${MY_SQL.escape(jsonDati["n_civ"])},${MY_SQL.escape(jsonDati["loc"])},${MY_SQL.escape(jsonDati["zip"])}` +
            `,${MY_SQL.escape(jsonDati["city"])},${MY_SQL.escape(jsonDati["province_code"])},${MY_SQL.escape(jsonDati["country"])}` +
            `,${MY_SQL.escape(jsonDati["telephone"])},${MY_SQL.escape(jsonDati["email"])},${MY_SQL.escape(jsonDati["magazine"])})`;

        POOL.query(QUERY, function (err, rows) {
            if (!err)
                response.status(200).send({});
            else
                next(err);
        });
    })
    .patch(function (request, response, next) {
        const jsonDati = request.body;
        for (let campo in jsonDati)
            jsonDati[campo] = campo == "email" ? jsonDati[campo] : jsonDati[campo].toString().trim().toUpperCase();

        const QUERY = `UPDATE private_groups SET name=${MY_SQL.escape(jsonDati["name"])},reference=${MY_SQL.escape(jsonDati["reference"])}` +
            `,address=${MY_SQL.escape(jsonDati["address"])},n_civ=${MY_SQL.escape(jsonDati["n_civ"])},loc=${MY_SQL.escape(jsonDati["loc"])}` +
            `,zip=${MY_SQL.escape(jsonDati["zip"])},city=${MY_SQL.escape(jsonDati["city"])},province_code=${MY_SQL.escape(jsonDati["province_code"])}` +
            `,country=${MY_SQL.escape(jsonDati["country"])},telephone=${MY_SQL.escape(jsonDati["telephone"])},email=${MY_SQL.escape(jsonDati["email"])}` + `
    ,magazine=${MY_SQL.escape(jsonDati["magazine"])} WHERE id=${MY_SQL.escape(jsonDati["id"])}`;

        DBQuery(QUERY, request, response, next);
    })
    .delete(function (request, response, next) {
        const jsonDati = request.query;
        const QUERY = `DELETE FROM private_groups WHERE id=${MY_SQL.escape(jsonDati["id"])}`;

        DBQuery(QUERY, request, response, next);
    });
//#endregion

//#region PRIVATE_MG_GROUPS
APP.route('/api/private_mg_groups')
    .post(function (request, response, next) {
        const jsonDati = request.body;
        jsonDati["name"] = jsonDati["name"].toString().trim().toUpperCase();
        const QUERY = `INSERT INTO private_mg_groups (name) VALUES (${MY_SQL.escape(jsonDati["name"])}` +

            POOL.query(QUERY, function (err, rows) {
                if (!err)
                    response.status(200).send({});
                else
                    next(err);
            });
    })
    .patch(function (request, response, next) {
        const jsonDati = request.body;
        jsonDati["name"] = jsonDati["name"].toString().trim().toUpperCase();
        const QUERY = `UPDATE private_mg_groups SET name=${MY_SQL.escape(jsonDati["name"])}`;

        DBQuery(QUERY, request, response, next);
    })
    .delete(function (request, response, next) {
        const jsonDati = request.query;
        const QUERY = `DELETE FROM private_mg_groups WHERE id=${MY_SQL.escape(jsonDati["id"])}`;

        DBQuery(QUERY, request, response, next);
    });
//#endregion

//#region PRIVATE_MG_ITEMS
APP.route('/api/private_mg_items')
    .get(function (request, response, next) {
        const QUERY = "SELECT private_mg_items.id, private_mg_items.id_group, private_mg_items.code," +
            "private_mg_items.name as nameItem, private_mg_items.description, private_mg_items.amountCuneo," +
            "private_mg_items.amountRoracco, private_mg_groups.name as nameGroup" +
            " FROM private_mg_items,private_mg_groups" +
            " WHERE private_mg_groups.id=private_mg_items.id_group";
        POOL.query(QUERY, function (err, rows) {
            if (!err) {
                //console.log(JSON.stringify(rows))
                response.status(200).send(rows);
            }
            else
                next(err);
        });
    })
    .post(function (request, response, next) {
        const jsonDati = request.body;
        jsonDati["code"] = jsonDati["code"].toString().trim().toUpperCase();
        jsonDati["nameItem"] = jsonDati["nameItem"].toString().trim().toUpperCase();
        jsonDati["description"] = jsonDati["description"].toString().trim().toUpperCase();

        const QUERY = `INSERT INTO private_mg_items (id_group,code,name,description,amountRoracco,amountCuneo)` +
            ` VALUES (${MY_SQL.escape(jsonDati["id_group"])},${MY_SQL.escape(jsonDati["code"])},${MY_SQL.escape(jsonDati["nameItem"])},` +
            `${MY_SQL.escape(jsonDati["description"])},${MY_SQL.escape(jsonDati["amountRoracco"])},${MY_SQL.escape(jsonDati["amountCuneo"])});`

        POOL.query(QUERY, function (err, rows) {
            if (!err)
                response.status(200).send({});
            else
                next(err);
        });
    })
    .patch(function (request, response, next) {
        const jsonDati = request.body;
        jsonDati["code"] = jsonDati["code"].toString().trim().toUpperCase();
        jsonDati["nameItem"] = jsonDati["nameItem"].toString().trim().toUpperCase();
        jsonDati["description"] = jsonDati["description"].toString().trim().toUpperCase();

        const QUERY = `UPDATE private_mg_items SET id_group=${MY_SQL.escape(jsonDati["id_group"])},code=${MY_SQL.escape(jsonDati["code"])},` +
            `name=${MY_SQL.escape(jsonDati["nameItem"])},description=${MY_SQL.escape(jsonDati["description"])},amountRoracco=${MY_SQL.escape(jsonDati["amountRoracco"])},` +
            `amountCuneo=${MY_SQL.escape(jsonDati["amountCuneo"])} WHERE id=${MY_SQL.escape(jsonDati["id"])}`;

        DBQuery(QUERY, request, response, next);
    })
    .delete(function (request, response, next) {
        const jsonDati = request.query;
        const QUERY = `DELETE FROM private_mg_items WHERE id=${MY_SQL.escape(jsonDati["id"])}`;

        DBQuery(QUERY, request, response, next);
    });
//#endregion

//------------PRIVATE_MG_PLACES -> crud non to be done, update by triggers

//#region PRIVATE_MG_TRADES 
/*
APP.route('/api/private_mg_trades')
    .post(function (request, response, next) {
        const jsonDati = request.body;
        const QUERY = `INSERT INTO private_mg_trades (id_stock,date,amount,)` +
            ` VALUES (${MY_SQL.escape(jsonDati["id_stock"])},${MY_SQL.escape(jsonDati["date"])},${MY_SQL.escape(jsonDati["amount"])});`

        DBQuery(QUERY, function (err, rows) {
            if (!err)
                response.status(200).send({});
            else
                next(err);
        });
    })
    .patch(function (request, response, next) {
        const jsonDati = request.body;
        const QUERY = `UPDATE private_mg_trades SET id_stock=${MY_SQL.escape(jsonDati["id_stock"])},date=${MY_SQL.escape(jsonDati["date"])},` +
            `amount=${MY_SQL.escape(jsonDati["amount"])} WHERE id=${MY_SQL.escape(jsonDati["id"])}`;

        DBQuery(QUERY, request, response, next);
    })
    .delete(function (request, response, next) {
        const jsonDati = request.query;
        const QUERY = `DELETE FROM private_mg_trades WHERE id=${MY_SQL.escape(jsonDati["id"])}`;

        DBQuery(QUERY, request, response, next);
    });
    */
//#endregion

//#region PRIVATE_PERSONS
APP.route('/api/private_persons')
    .get(function (request, response, next) {
        const jsonDati = request.query;
        let QUERY = `SELECT * FROM private_persons`;
        //cognome o nome o codice fiscale
        if (jsonDati.cfc != "" && jsonDati.cfc != null)
            QUERY += ` WHERE cfc=${MY_SQL.escape(jsonDati.cfc)}`;
        else {
            let name = false;
            if (jsonDati.name != "" && jsonDati.name != null) {
                QUERY += ` WHERE name LIKE ${MY_SQL.escape(jsonDati.name + '%')}`;
                name = true;
            }
            if (jsonDati.surname != "" && jsonDati.surname != null) {
                if (name)
                    QUERY += ` AND surname LIKE ${MY_SQL.escape(jsonDati.surname + '%')}`
                else
                    QUERY += ` WHERE surname LIKE ${MY_SQL.escape(jsonDati.surname + '%')}`;
            }
        }
        QUERY += ";";
        POOL.query(QUERY, function (err, rows) {
            if (!err)
                response.status(200).send(rows);
            else
                next(err);
        });
    })
    .post(function (request, response, next) {
        const jsonDati = request.body;
        for (let campo in jsonDati)
            jsonDati[campo] = campo == "email" ? jsonDati[campo] : jsonDati[campo].toString().trim().toUpperCase();

        const QUERY = `INSERT INTO private_persons (cfc,surname,name,address,n_civ,loc,zip,city,province_code,country,telephone,email,magazine)` +
            ` VALUES (${MY_SQL.escape(jsonDati["cfc"])},${MY_SQL.escape(jsonDati["surname"])},${MY_SQL.escape(jsonDati["name"])}` +
            `,${MY_SQL.escape(jsonDati["address"])},${MY_SQL.escape(jsonDati["n_civ"])},${MY_SQL.escape(jsonDati["loc"])},${MY_SQL.escape(jsonDati["zip"])}` +
            `,${MY_SQL.escape(jsonDati["city"])},${MY_SQL.escape(jsonDati["province_code"])},${MY_SQL.escape(jsonDati["country"])}` +
            `,${MY_SQL.escape(jsonDati["telephone"])},${MY_SQL.escape(jsonDati["email"])},${MY_SQL.escape(jsonDati["magazine"])})`;
        POOL.query(QUERY, function (err, rows) {
            if (!err)
                response.status(200).send({});
            else
                next(err);
        });
    })
    .patch(function (request, response, next) {
        const jsonDati = request.body;
        for (let campo in jsonDati)
            jsonDati[campo] = campo == "email" ? jsonDati[campo] : jsonDati[campo].toString().trim().toUpperCase();

        const QUERY = `UPDATE private_persons SET cfc=${MY_SQL.escape(jsonDati["cfc"])},surname=${MY_SQL.escape(jsonDati["surname"])}` +
            `,name=${MY_SQL.escape(jsonDati["name"])},address=${MY_SQL.escape(jsonDati["address"])},n_civ=${MY_SQL.escape(jsonDati["n_civ"])},loc=${MY_SQL.escape(jsonDati["loc"])}` +
            `,zip=${MY_SQL.escape(jsonDati["zip"])},city=${MY_SQL.escape(jsonDati["city"])},province_code=${MY_SQL.escape(jsonDati["province_code"])}` +
            `,country=${MY_SQL.escape(jsonDati["country"])},telephone=${MY_SQL.escape(jsonDati["telephone"])},email=${MY_SQL.escape(jsonDati["email"])}` + `
    ,magazine=${MY_SQL.escape(jsonDati["magazine"])} WHERE id=${MY_SQL.escape(jsonDati["id"])}`;

        DBQuery(QUERY, request, response, next);
    })
    .delete(function (request, response, next) {
        const jsonDati = request.query;
        const QUERY = `DELETE FROM private_persons WHERE id=${MY_SQL.escape(jsonDati["id"])}`;

        DBQuery(QUERY, request, response, next);
    });
APP.get('/api/private_persons/:data', function (request, response, next) {
    let data = request.params.data;

    //string name, surname or cfc

    let QUERY = `SELECT * FROM private_persons WHERE name LIKE ${MY_SQL.escape(data + '%')} OR surname LIKE ${MY_SQL.escape(data + '%')} OR cfc LIKE ${MY_SQL.escape(data + '%')};`;
    console.log(QUERY);
    console.log(data);
    POOL.query(QUERY, function (err, rows) {
        if (!err)
            response.status(200).send(rows);
        else
            next(err);
    });
});
//#endregion

//#region crud privati

APP.get('/table/:tableName', function (request, response, next) {
    POOL.query(`SELECT * FROM ${request.params.tableName};`, function (err, rows, fields) {
        if (!err) {
            response.send({
                rows: rows,
                fields: fields
            });
        }
        else
            next(err);
    });
});

APP.get('/api/private_donations_persons', function (request, response, next) {
    const jsonDati = request.query;

    //causale
    //conto
    //cognome
    //nome
    //mese/anno oppure da/a

    let SELECT = "SELECT private_donations_persons.id, private_persons.id as idP, private_persons.surname, private_persons.name as nameP, private_donations_persons.date_payment, " +
        "private_donations_persons.date_registration, private_causals.id as idC, private_causals.name as nameC, " +
        "private_accounts.id as idA, private_accounts.name as nameA, private_donations_persons.value " +// SUM(private_donations_persons.value) as sumValues "+
        "FROM private_donations_persons,private_persons,private_causals,private_accounts " +
        "WHERE private_donations_persons.id_person=private_persons.id AND " +
        "private_donations_persons.id_causal=private_causals.id AND " +
        "private_donations_persons.id_account=private_accounts.id";

    let SELECTSUM = "SELECT SUM(private_donations_persons.value) as sumValues " +
        "FROM private_donations_persons,private_persons,private_causals,private_accounts " +
        "WHERE private_donations_persons.id_person=private_persons.id AND " +
        "private_donations_persons.id_causal=private_causals.id AND " +
        "private_donations_persons.id_account=private_accounts.id";
    let QUERY = "";
    let data = false;
    //controllo prima se c'è già la where e se non c'è la metto

    //#region CODICE UFFICIALE

    //causale
    if (jsonDati.causal != "") {
        QUERY += ` AND private_causals.id=${MY_SQL.escape(jsonDati.causal)}`;
    }
    //conto
    if (jsonDati.account != "") {
        QUERY += ` AND private_accounts.id=${MY_SQL.escape(jsonDati.account)}`;
    }
    //controllo se c'è anno
    if ("year" in jsonDati && jsonDati.year != "") {
        if (jsonDati.month != "") {
            jsonDati.dataInizio = new Date(`${jsonDati.year}/${jsonDati.month}/1`);
            if (jsonDati.month == 1 || jsonDati.month == 3 || jsonDati.month == 5 || jsonDati.month == 7 || jsonDati.month == 8 || jsonDati.month == 10 || jsonDati.month == 12)
                jsonDati.dataFine = new Date(`${jsonDati.year}/${jsonDati.month}/31`);
            else {
                if (jsonDati.month == 2) {
                    if (((jsonDati.year % 4 == 0) && (jsonDati.year % 100 != 0)) || (jsonDati.year % 400 == 0))
                        jsonDati.dataFine = new Date(`${jsonDati.year}/${jsonDati.month}/29`);
                    else
                        jsonDati.dataFine = new Date(`${jsonDati.year}/${jsonDati.month}/28`);
                }
                else
                    jsonDati.dataFine = new Date(`${jsonDati.year}/${jsonDati.month}/30`);
            }
        }
        else {
            jsonDati.dataInizio = new Date(`${jsonDati.year}/01/01`);
            jsonDati.dataFine = new Date(`${jsonDati.year}/12/31`);
        }
        QUERY += ` AND private_donations_persons.date_payment BETWEEN ${MY_SQL.escape(jsonDati.dataInizio)} AND ${MY_SQL.escape(jsonDati.dataFine)}`;
    }
    //controllo se c'è almeno uno tra da/a
    if ("dateFrom" in jsonDati && (jsonDati.dateFrom != "" || jsonDati.dateTo != "")) {
        if (jsonDati.dateFrom != "" && jsonDati.dateTo != "") {
            data = true;
            let meseDa = jsonDati.dateFrom.split('/')[0];
            let annoDa = jsonDati.dateFrom.split('/')[1];
            let meseA = jsonDati.dateTo.split('/')[0];
            let annoA = jsonDati.dateTo.split('/')[1];
            jsonDati.dataDaAMinore = new Date(`${annoDa}/${meseDa}/01`);
            if (meseA == 1 || meseA == 3 || meseA == 5 || meseA == 7 || meseA == 8 || meseA == 10 || meseA == 12)
                jsonDati.dataDaAMaggiore = new Date(`${annoA}/${meseA}/31`);
            else {
                if (meseA == 2) {
                    if (((annoA % 4 == 0) && (annoA % 100 != 0)) || (annoA % 400 == 0))
                        jsonDati.dataDaAMaggiore = new Date(`${annoA}/${meseA}/29`);
                    else
                        jsonDati.dataDaAMaggiore = new Date(`${annoA}/${meseA}/28`);
                }
                else
                    jsonDati.dataDaAMaggiore = new Date(`${annoA}/${meseA}/30`);
            }
            QUERY += ` AND private_donations_persons.date_payment BETWEEN ${MY_SQL.escape(jsonDati.dataDaAMinore)} AND ${MY_SQL.escape(jsonDati.dataDaAMaggiore)}`;
        }
        if (!data && jsonDati.dateFrom != "") {
            let meseDa = jsonDati.dateFrom.split('/')[0];
            let annoDa = jsonDati.dateFrom.split('/')[1];
            jsonDati.dataDaAMinore = new Date(`${annoDa}/${meseDa}/01`);
            QUERY += ` AND private_donations_persons.date_payment>=${MY_SQL.escape(jsonDati.dataDaAMinore)}`;
        }
        if (!data && jsonDati.dateTo != "") {
            let meseA = jsonDati.dateTo.split('/')[0];
            let annoA = jsonDati.dateTo.split('/')[1];
            if (meseA == 1 || meseA == 3 || meseA == 5 || meseA == 7 || meseA == 8 || meseA == 10 || meseA == 12)
                jsonDati.dataDaAMaggiore = new Date(`${annoA}/${meseA}/31`);
            else {
                if (meseA == 2) {
                    if (((annoA % 4 == 0) && (annoA % 100 != 0)) || (annoA % 400 == 0))
                        jsonDati.dataDaAMaggiore = new Date(`${annoA}/${meseA}/29`);
                    else
                        jsonDati.dataDaAMaggiore = new Date(`${annoA}/${meseA}/28`);
                }
                else
                    jsonDati.dataDaAMaggiore = new Date(`${annoA}/${meseA}/30`);
            }
            QUERY += ` AND private_donations_persons.date_payment<=${MY_SQL.escape(jsonDati.dataDaAMaggiore)}`;
        }
    }
    //gestione nomi e cognomi
    if (jsonDati.surname != "") {
        QUERY += ` AND private_persons.surname LIKE ${MY_SQL.escape(jsonDati.surname + '%')}`;
    }
    if (jsonDati.name != "") {
        QUERY += ` AND private_persons.name LIKE ${MY_SQL.escape(jsonDati.name + '%')}`;
    }

    //#endregion
    QUERY += " ORDER BY private_donations_persons.date_payment DESC;";

    let risp = {};
    POOL.query(SELECT + QUERY + SELECTSUM + QUERY, [1, 2], function (err, rows) {
        if (!err) {
            risp.rows = rows[0];
            risp.sum = rows[1][0].sumValues;
            response.status(200).send(risp);
        }
        else
            next(err);
    });
});

APP.get('/api/private_donations_groups', function (request, response, next) {
    const jsonDati = request.query;

    //causale
    //conto
    //cognome
    //nome
    //mese/anno oppure da/a

    let SELECT = "SELECT private_donations_groups.id, private_groups.id as idG, private_groups.name, private_groups.reference, private_donations_groups.date_payment, " +
        "private_donations_groups.date_registration, private_causals.id as idC, private_causals.name as nameC, " +
        "private_accounts.id as idA, private_accounts.name as nameA, private_donations_groups.value " +
        "FROM private_donations_groups,private_groups,private_causals,private_accounts " +
        "WHERE private_donations_groups.id_group=private_groups.id AND " +
        "private_donations_groups.id_causal=private_causals.id AND " +
        "private_donations_groups.id_account=private_accounts.id";
    let SELECTSUM = "SELECT SUM(private_donations_groups.value) as sumValues " +
        "FROM private_donations_groups,private_groups,private_causals,private_accounts " +
        "WHERE private_donations_groups.id_group=private_groups.id AND " +
        "private_donations_groups.id_causal=private_causals.id AND " +
        "private_donations_groups.id_account=private_accounts.id";
    let QUERY = "";
    let data = false;
    //controllo prima se c'è già la where e se non c'è la metto

    //causale
    if (jsonDati.causal != "") {
        QUERY += ` AND private_causals.id=${MY_SQL.escape(jsonDati.causal)}`;
    }
    //conto
    if (jsonDati.account != "") {
        QUERY += ` AND private_accounts.id=${MY_SQL.escape(jsonDati.account)}`;
    }
    //controllo se c'è anno
    if ("year" in jsonDati && jsonDati.year != "") {
        if (jsonDati.month != "") {
            jsonDati.dataInizio = new Date(`${jsonDati.year}/${jsonDati.month}/1`);
            if (jsonDati.month == 1 || jsonDati.month == 3 || jsonDati.month == 5 || jsonDati.month == 7 || jsonDati.month == 8 || jsonDati.month == 10 || jsonDati.month == 12)
                jsonDati.dataFine = new Date(`${jsonDati.year}/${jsonDati.month}/31`);
            else {
                if (jsonDati.month == 2) {
                    if (((jsonDati.year % 4 == 0) && (jsonDati.year % 100 != 0)) || (jsonDati.year % 400 == 0))
                        jsonDati.dataFine = new Date(`${jsonDati.year}/${jsonDati.month}/29`);
                    else
                        jsonDati.dataFine = new Date(`${jsonDati.year}/${jsonDati.month}/28`);
                }
                else
                    jsonDati.dataFine = new Date(`${jsonDati.year}/${jsonDati.month}/30`);
            }
        }
        else {
            jsonDati.dataInizio = new Date(`${jsonDati.year}/01/01`);
            jsonDati.dataFine = new Date(`${jsonDati.year}/12/31`);
        }
        QUERY += ` AND private_donations_groups.date_payment BETWEEN ${MY_SQL.escape(jsonDati.dataInizio)} AND ${MY_SQL.escape(jsonDati.dataFine)}`;
    }
    //controllo se c'è almeno uno tra da/a
    if ("dateFrom" in jsonDati && (jsonDati.dateFrom != "" || jsonDati.dateTo != "")) {
        if (jsonDati.dateFrom != "" && jsonDati.dateTo != "") {
            data = true;
            let meseDa = jsonDati.dateFrom.split('/')[0];
            let annoDa = jsonDati.dateFrom.split('/')[1];
            let meseA = jsonDati.dateTo.split('/')[0];
            let annoA = jsonDati.dateTo.split('/')[1];
            jsonDati.dataDaAMinore = new Date(`${annoDa}/${meseDa}/01`);
            if (meseA == 1 || meseA == 3 || meseA == 5 || meseA == 7 || meseA == 8 || meseA == 10 || meseA == 12)
                jsonDati.dataDaAMaggiore = new Date(`${annoA}/${meseA}/31`);
            else {
                if (meseA == 2) {
                    if (((annoA % 4 == 0) && (annoA % 100 != 0)) || (annoA % 400 == 0))
                        jsonDati.dataDaAMaggiore = new Date(`${annoA}/${meseA}/29`);
                    else
                        jsonDati.dataDaAMaggiore = new Date(`${annoA}/${meseA}/28`);
                }
                else
                    jsonDati.dataDaAMaggiore = new Date(`${annoA}/${meseA}/30`);
            }
            QUERY += ` AND private_donations_groups.date_payment BETWEEN ${MY_SQL.escape(jsonDati.dataDaAMinore)} AND ${MY_SQL.escape(jsonDati.dataDaAMaggiore)}`;
        }
        if (!data && jsonDati.dateFrom != "") {
            let meseDa = jsonDati.dateFrom.split('/')[0];
            let annoDa = jsonDati.dateFrom.split('/')[1];
            jsonDati.dataDaAMinore = new Date(`${annoDa}/${meseDa}/01`);
            QUERY += ` AND private_donations_groups.date_payment>=${MY_SQL.escape(jsonDati.dataDaAMinore)}`;
        }
        if (!data && jsonDati.dateTo != "") {
            let meseA = jsonDati.dateTo.split('/')[0];
            let annoA = jsonDati.dateTo.split('/')[1];
            if (meseA == 1 || meseA == 3 || meseA == 5 || meseA == 7 || meseA == 8 || meseA == 10 || meseA == 12)
                jsonDati.dataDaAMaggiore = new Date(`${annoA}/${meseA}/31`);
            else {
                if (meseA == 2) {
                    if (((annoA % 4 == 0) && (annoA % 100 != 0)) || (annoA % 400 == 0))
                        jsonDati.dataDaAMaggiore = new Date(`${annoA}/${meseA}/29`);
                    else
                        jsonDati.dataDaAMaggiore = new Date(`${annoA}/${meseA}/28`);
                }
                else
                    jsonDati.dataDaAMaggiore = new Date(`${annoA}/${meseA}/30`);
            }
            QUERY += ` AND private_donations_groups.date_payment<=${MY_SQL.escape(jsonDati.dataDaAMaggiore)}`;
        }
    }
    //gestione nomi e cognomi
    if (jsonDati.idGroup != 0)
        QUERY += ` AND private_groups.id=${MY_SQL.escape(jsonDati.idGroup)}`;

    QUERY += " ORDER BY private_donations_groups.date_payment DESC;";

    let risp = {};
    POOL.query(SELECT + QUERY + SELECTSUM + QUERY, [1, 2], function (err, rows) {
        if (!err) {
            risp.rows = rows[0];
            risp.sum = rows[1][0].sumValues;
            response.status(200).send(risp);
        }
        else
            next(err);
    });
});

//#endregion
/*
APP.get('/debug/:tableName/:operation', function (request, response, next) {
    const TABLE_NAME = request.params.tableName.toLowerCase();
    const OPERATION = request.params.operation.toLowerCase();
    const QUERY = FS.readFileSync(`./query/${TABLE_NAME}/${OPERATION}.sql`, "utf8");
    DB.query(QUERY, function (err, rows) {
        DB.release();
        if (!err)
            response.status(200).send({});
        else
            next(err);
    });
});*/

APP.post('/passwordReset', function (request, response, next) {
    const username = request.body.username;
    console.log(username);
    const QUERY = `SELECT email FROM users WHERE BINARY username='${username}'`;
    POOL.query(QUERY, function (err, rows) {
        if (!err) {
            if (rows.length == 0)
                response.status(404).send('"NOK"');
            else {
                const mail = rows[0].email;
                console.log("mail: " + mail);
                const rndPsw = Math.random().toString(36).substr(2, 8);
                //console.log("password nuova: " + rndPsw);
                let hashPsw = BCRYPT.hashSync(rndPsw, SALT_VALUE);
                console.log("994: reset mail");
                const QUERYUPDATE = `UPDATE users SET password='${hashPsw}' WHERE username='${username}'`;
                POOL.query(QUERYUPDATE, function (err, rows) {
                    if (!err) {
                        console.log("998: invio mail");
                        let mailOptions = {
                            from: 'gestioneProgettoCDM@gmail.com',
                            to: `${mail}`,
                            subject: 'Reset password ~ Reset senha',
                            text: `La tua nuova password è: ${rndPsw}\n\nSua nova senha è: ${rndPsw}`,
                            html: `
							<head><link href="https://emoji-css.afeld.me/emoji.css" rel="stylesheet"></head>
							<body>
								<i class="em em-flag-it" aria-role="presentation" aria-label="Italian Flag"></i> La tua nuova password è: ${rndPsw}<br/><br/>
								<i class="em em-flag-br" aria-role="presentation" aria-label="Brasilian Flag"></i> Sua nova senha è: ${rndPsw}
							</body>`
                        };

                        TRANSPORTER.sendMail(mailOptions, function (error, info) {
                            if (error) {
                                console.log(error);
                                next(error);
                            } else {
                                response.status(200).send({});
                            }
                        });

                    }
                    else {
                        next(err);
                    }
                });

            }
        }
        else
            next(err);
    });
});

APP.use("/logout", function (request, response, next) {
    response.clearCookie("token").send('"OK"');
});

APP.use(function (err, req, res, next) {
    console.log(err);
    res.status(500).send(err);
});

const SERVER = HTTPS.createServer(CREDENTIALS, APP);
//const SERVER = HTTP.createServer(APP);

SERVER.listen(PORT, function () {
    console.log('Express server inizializzato sulla porta ' + PORT);
});

function creaToken(obj) {
    let token = JWT.sign({
        "username": obj.username,
        "type": obj.type,
        "exp": obj.exp || Math.floor(Date.now() / 1000) + TIMEOUT_TOKEN,
        "iat": obj.iat || Math.floor(Date.now() / 1000)
    }, PRIVATE_KEY);
    return token;
}

function DBQuery(QUERY, request, response, next) {
    POOL.getConnection(function (err, connection) {
        if (!err) {
            let conn = connection;
            connection.changeUser({ user: request.token.username }, function (err) {
                if (!err)
                    conn.query(QUERY, function (err, rows) {
                        conn.release();
                        if (!err)
                            response.status(200).send({});
                        else
                            next(err);
                    });
                else
                    next(err);
            });
        } else
            next(err);
    });
}