(ns backend.db
  (:require [next.jdbc :as jdbc]))

(def db-spec {:dbtype "sqlite" :dbname "todos.db"})

(defn init-db! []
  (jdbc/execute! db-spec
    ["CREATE TABLE IF NOT EXISTS todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        text TEXT NOT NULL,
        completed INTEGER DEFAULT 0,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )"])
  (println "Banco de dados inicializado com sucesso!"))

(defn list-todos []
  (jdbc/execute! db-spec
    ["SELECT id, text, completed FROM todos ORDER BY created_at DESC"]))

(defn create-todo! [text]
  (let [result (jdbc/execute-one! db-spec
                 ["INSERT INTO todos (text, completed) VALUES (?, 0)" text]
                 {:return-keys true})]
    {:id (:last_insert_rowid() result)
     :text text
     :completed 0}))

(defn toggle-todo! [id]
  (let [current (jdbc/execute-one! db-spec
                  ["SELECT id, text, completed FROM todos WHERE id = ?" id])]
    (when current
      (let [new-completed (if (zero? (:completed current)) 1 0)]
        (jdbc/execute-one! db-spec
          ["UPDATE todos SET completed = ? WHERE id = ?" new-completed id])
        {:id id
         :text (:text current)
         :completed new-completed}))))

;; Remove uma tarefa
(defn delete-todo! [id]
  (let [result (jdbc/execute-one! db-spec
                 ["DELETE FROM todos WHERE id = ?" id])]
    (pos? (::jdbc/update-count result))))