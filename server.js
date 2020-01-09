var _expressPackage = require("express");
var _bodyParserPackage = require("body-parser");
var _sqlPackage = require("mssql");
var _cors = require("cors");

var app = _expressPackage();
app.use(_bodyParserPackage.json());

/*app.use((request, result, next)=>{
    result.header("Access-Control-Allow-Origin", "*");  
    result.header("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT");  
    result.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, contentType,Content-Type, Accept, Authorization");  
    next();  
});*/

app.use(_cors());

var server = app.listen(process.env.PORT || 4000, () => {
    var port = server.address().port;
    console.log("App now running on port", port);
});

/*var databaseConfiguration = {
    user: 'sa',
    password: 'Password1234',
    server: 'DESKTOP-4PUAQN6\\SQLEXPRESS', // You can use 'localhost\\instance' to connect to named instance
    database: 'UserManagement',
    options: {
        trustedConnection: true,
    }
};*/

var databaseConfiguration = {
    user: 'sa',
    password: 'Password1234',
    server: 'P6665\\SQLEXPRESS', // You can use 'localhost\\instance' to connect to named instance
    database: 'UserDatabase',
    options: {
        trustedConnection: true,
    }
};

var QueryToExecuteInDatabase = (response, queryString) => {
    _sqlPackage.close();
    _sqlPackage.connect(databaseConfiguration, (error) => {
        if (error) {
            console.log("Error while connecting to User Database before request: -" + error);
            response.send(error);
        }
        else {
            var request = new _sqlPackage.Request();
            request.query(queryString, (error, responseResult) => {
                if (error) {
                    console.log("Error while connecting to User Database : -" + error);
                    response.send(error);
                }
                else {
                    console.log(responseResult);
                    response.send(responseResult);
                }
            });
        }
    });
}

//GET API
app.get("/users", (_request, _result) => {
    var SqlQuery = `
    SELECT [userId], [userName], [email], [FirstName], [LastName], [StartDate], [EndDate], [RoleName] from Users JOIN UserDetails on Users.id = UserDetails.userId JOIN UserRoles on Users.userRoleId = UserRoles.id;   
    `;
    QueryToExecuteInDatabase(_result, SqlQuery);
});

//POST API
app.post("/users", (_request, _result) => {
    console.log("creating sql post query");
    var data = _request.body.body;
    console.log(data);
    var SqlQuery = `
    INSERT INTO UserDetails ([FirstName], [LastName], [StartDate], [EndDate]) VALUES ('${data.FirstName}', '${data.LastName}', '${data.StartDate}', '${data.EndDate}');
    INSERT INTO Users ([userRoleId], [userName], [email], [password]) VALUES ('${data.Role}', '${data.userName}', '${data.email}', '${data.Password}');  
    `;
    console.log(SqlQuery)
    QueryToExecuteInDatabase(_result, SqlQuery);
});

app.put("/users", (_request, _result) => {
    console.log("creating sql update query");
    console.log(_request.body)
    var data = _request.body;
    console.log(data);
    var SqlQuery = `
    UPDATE UserDetails SET FirstName = '${data.FirstName}', LastName = '${data.LastName}', StartDate = '${data.StartDate.substr(0, data.StartDate.indexOf("T"))}', EndDate = '${data.EndDate.substr(0, data.EndDate.indexOf("T"))}' WHERE [userId] = '${data.userId}';
    `;
    QueryToExecuteInDatabase(_result, SqlQuery);
});

app.delete("/users", (_request, _result) => {
    console.log("creating sql delete query");
    console.log(_request.body)
    var userId = _request.body.userId;
    var SqlQuery =
        `
    DELETE FROM Users WHERE id = ${userId}
    DELETE FROM UserDetails WHERE userId = ${userId}
    `;
    console.log(SqlQuery);
    QueryToExecuteInDatabase(_result, SqlQuery);
});

app.post('/login', (_request, _result) => {
    console.log("creating sql login query");
    var data = _request.body.body;
    console.log(_request.body);
    var SqlQuery =
        `
    SELECT [userId], [userName], [email], [FirstName], [LastName], [StartDate], [EndDate], [RoleName] from Users JOIN UserDetails on Users.id = UserDetails.userId JOIN UserRoles on Users.userRoleId = UserRoles.id WHERE userName = '${data.userName}' AND  password = '${data.password}';
    `;
    console.log(SqlQuery);
    QueryToExecuteInDatabase(_result, SqlQuery);
});
