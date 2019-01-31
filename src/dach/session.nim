import db_mysql
import strutils

type
  Session* = DbConn

proc newSession*(connection, username, password, db: string, createTable: bool = true): Session =
  ## Create Session instance
  result = open(connection, username, password, db)
  discard setEncoding(result, "utf8mb4")
  
  # create a "session" table if it does not exist
  if not result.getValue(sql"SHOW TABLES").contains("session"):
    result.exec(sql"""
    CREATE TABLE session (
      id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
      k VARCHAR(32) NOT NULL,
      val VARCHAR(32) NOT NULL
    )""")

proc rawGet(db: Session, key: string): string =
  let key = dbQuote(key)
  result = db.getValue(sql"SELECT val FROM session WHERE k=?", key)

proc `[]`*(db: Session, key: string): string =
  ## Get value from session storage
  db.rawGet(key)
