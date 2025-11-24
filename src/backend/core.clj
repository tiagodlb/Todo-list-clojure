(ns backend.core
  (:require [ring.adapter.jetty :as jetty]
            [reitit.ring :as ring]
            [ring.middleware.json :refer [wrap-json-body wrap-json-response]]
            [ring.middleware.cors :refer [wrap-cors]]
            [backend.db :as db]))

(defn get-todos [_]
  {:status 200
   :body (db/list-todos)})

(defn create-todo [request]
  (let [todo-data (get-in request [:body :text])]
    (if (and todo-data (not (empty? todo-data)))
      (let [new-todo (db/create-todo! todo-data)]
        {:status 201
         :body new-todo})
      {:status 400
       :body {:error "Text field is required"}})))

(defn toggle-todo [request]
  (let [id (parse-long (get-in request [:path-params :id]))]
    (if-let [updated-todo (db/toggle-todo! id)]
      {:status 200
       :body updated-todo}
      {:status 404
       :body {:error "Todo not found"}})))

(defn delete-todo [request]
  (let [id (parse-long (get-in request [:path-params :id]))]
    (if (db/delete-todo! id)
      {:status 204}
      {:status 404
       :body {:error "Todo not found"}})))

(def routes
  (ring/ring-handler
    (ring/router
      [["/api"
        ["/todos" {:get get-todos
                   :post create-todo}]
        ["/todos/:id/toggle" {:put toggle-todo}]
        ["/todos/:id" {:delete delete-todo}]]])))

(def app
  (-> routes
      (wrap-json-body {:keywords? true})
      wrap-json-response
      (wrap-cors :access-control-allow-origin [#"http://localhost:8020"]
                 :access-control-allow-methods [:get :post :put :delete]
                 :access-control-allow-headers ["Content-Type"])))

(defn -main []
  (db/init-db!)
  (jetty/run-jetty app {:port 3000 :join? false})
  (println "Servidor rodando em http://localhost:3000"))