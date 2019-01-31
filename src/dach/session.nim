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

proc hasKey(db: Session, key: string): bool =
  # TODO: Fix
  if db.rawGet(key) == "":
    return false
  else:
    return true

proc rawInsert(db: Session, key, value: string) =
  let
    key = dbQuote(key)
    value = dbQuote(value)
#  db.tryInsertId(sql"INSERT INTO session (l, val) VALUES (?, ?)", key, value)
  db.exec(sql"INSERT INTO session (k, val) VALUES (?, ?)", key, value)

proc update(db: Session, key, value: string) =
  let
    key = dbQuote(key)
    value = dbQuote(value)
  db.exec(sql"UPDATE session SET val=? WHERE k=?", value, key)

proc `[]=`*(db: Session, key, value: string) =
  ## Insert Key-Value in session. If key exists, update value.
  if db.hasKey(key):
    db.update(key, value)
  else:
    db.rawInsert(key, value)

proc del*(db: Session, key: string) =
  ## Delete Key-Value from session
  db.exec(sql"DELETE FROM session WHERE k=?", key)

