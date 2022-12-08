# Casa Do Menor project
This is a project made for [Casa do Menor](https://casadomenor.org/?lang=en) not for profit organization, by me and my two former classmates Serravite Lorenzo and Pepe Francesco at I.I.S. G. Vallauri for our high school diploma thesis. 

The files hosted in this repository are not in their final form, because the project is still maintained by newer students which are improving its functionalities and resolving the pending issues.

We started working from scratch in late 2019 followed by our teacher and school vice-principal Barbero Alberto, we talked with people working at Casa do Menor and analyzed their former management system, which was just about saving donations from people and little organizations. We were asked to update it with the management of projects and houses (Casa do Menor works also with big organizations like Caritas or CEI that donate directly for important projects like building new houses or schools, some example [here](https://casadomenor.org/projects-in-brazil/?lang=en)), bank accounts, improved queries on data, management of the warehouse and the logging of every action.

The first month was dedicated only to the understanding of their needs and finding the best solution tailored for them, then we moved to database planning and starting with the web app development. This version is done with Vue.js, the server is written in Node.js and uses express.js as framework, the database is based on mySQL.

![](https://raw.githubusercontent.com/gigianni/CasaDoMenor/main/img/ux-comparison.png?token=GHSAT0AAAAAAB3NAJYWE2IJOKFOKWMGTB2MY4SB4XQ)
*UI comparison, on the left their original system on the right ours*

# My part: the DB and part of the Server
I entirely designed the DB on which we based the whole project construction, then I moved to help Francesco coding the server meanwhile Lorenzo was developing the front-end part.

## Privates
![](https://github.com/gigianni/CasaDoMenor/blob/main/img/db-diagram-privates.png)

The private part comprends donation by people listed as persons and little groups/organizations listed as groups.

This part was already present on their old system in a not normalized way. This led to the creation of records in some table with column that should be referenced from other tables left empty or wrongly filled, I have passed some day looking for those records and found, between the >20.000 records about donations, more than 16 000 euros of contribution attribuited to not existent people, so developing the new databases had also a part of working with the organization and checking their archives.

## Warehouse
![](https://user-images.githubusercontent.com/103031839/206490402-034fc401-5785-40bb-845f-8bcb9dbc8c20.png)

The warehouse is managed by 3 tables, the webapp works only on the items and group by setting the new quantity of a specified item, the trades which memorize every movement in the warehouse is updated by a trigger.

## Projects
![](https://user-images.githubusercontent.com/103031839/206492334-6bc1286e-d5df-4171-a768-ca624eb91e3a.png)

The projects part of the db was done entirely from scratch, until then they only used few spare excel files hosted on google drive.

The projects are for example the construction of a compound of houses which has been financied by a big entity like C.E.I. (Episcopal Conference of Italy) or Caritas, therefore Casa do Menor must report all the informations about how the funding are used with specific deadlines. 

## Log
![](https://user-images.githubusercontent.com/103031839/206501022-5daba660-cc0c-4a66-a7e2-f6f60f62e4e0.png)

We were asked to log every update or delete action on the database with the user who made it and when it happened. So for every table which can be update or deleted from the WebApp there are two triggers like the one shown below:
```
CREATE TRIGGER private_persons_update
BEFORE UPDATE ON private_persons
FOR EACH ROW
INSERT INTO log SET
  tableName='private_persons',
  recordID=OLD.id,
  idType='int',
  record=CONCAT(COALESCE(OLD.cfc,''), ';',COALESCE(OLD.surname,''), ';',COALESCE(OLD.name,''), ';',COALESCE(OLD.address,''), ';',COALESCE(OLD.n_civ,''), ';',COALESCE(OLD.loc,''), ';',COALESCE(OLD.zip,''), ';',COALESCE(OLD.city,''), ';',COALESCE(OLD.province_code,''), ';',COALESCE(OLD.country,''), ';',COALESCE(OLD.telephone,''), ';',COALESCE(OLD.email,''), ';',COALESCE(OLD.magazine)),
  username=USER(),
  updateDate=NOW(),
  auditType='U'
```
In the log table we save the whole old record.
For saving the username the trigger directly get it by the webapp --> db connection, this works because we have an 1:1 corrispondence between webapp and mysql DB users, then I personally coded the connection part in the Node.js file which holds a pool of connections with different user each, this is convenient in this case because we foreseed about maximun 3-5 people using the site simultaneously.
