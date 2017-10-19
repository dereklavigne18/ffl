mysql = require 'mysql'

module.exports = {
  executeQuery: (sql, callback) ->
    connection = mysql.createConnection {
        host: "localhost",
        user: "squidward",
        password: "tenticles",
        database: "ffl"
    }
    query = connection.query(sql, callback)
}
