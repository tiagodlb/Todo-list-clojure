(ns frontend.app
  (:require [reagent.core :as r]
            [reagent.dom :as rdom]
            [ajax.core :refer [GET POST PUT DELETE]]))

;; URL da API
(def api-url "http://localhost:3000/api")

;; Estado da aplicação
(defonce app-state
  (r/atom {:todos []
           :loading? true
           :new-todo-text ""}))

;; Funções de comunicação com a API
(defn fetch-todos! []
  (swap! app-state assoc :loading? true)
  (GET (str api-url "/todos")
       {:handler (fn [response]
                   (swap! app-state assoc
                          :todos response
                          :loading? false))
        :error-handler (fn [error]
                         (js/console.error "Erro ao buscar todos:" error)
                         (swap! app-state assoc :loading? false))
        :response-format :json
        :keywords? true}))

(defn create-todo! [text]
  (when (not (empty? text))
    (POST (str api-url "/todos")
          {:params {:text text}
           :format :json
           :handler (fn [response]
                      (swap! app-state update :todos conj response)
                      (swap! app-state assoc :new-todo-text ""))
           :error-handler (fn [error]
                            (js/console.error "Erro ao criar todo:" error))
           :response-format :json
           :keywords? true})))

(defn toggle-todo! [id]
  (PUT (str api-url "/todos/" id "/toggle")
       {:handler (fn [response]
                   (swap! app-state update :todos
                          (fn [todos]
                            (mapv #(if (= (:id %) id) response %) todos))))
        :error-handler (fn [error]
                         (js/console.error "Erro ao alternar todo:" error))
        :response-format :json
        :keywords? true}))

(defn delete-todo! [id]
  (DELETE (str api-url "/todos/" id)
          {:handler (fn [_]
                      (swap! app-state update :todos
                             (fn [todos]
                               (filterv #(not= (:id %) id) todos))))
           :error-handler (fn [error]
                            (js/console.error "Erro ao deletar todo:" error))}))

;; Componentes da UI
(defn todo-input []
  [:div.input-group
   [:input {:type "text"
            :placeholder "Digite uma nova tarefa..."
            :value (:new-todo-text @app-state)
            :on-change #(swap! app-state assoc :new-todo-text (-> % .-target .-value))
            :on-key-press #(when (= (.-key %) "Enter")
                            (create-todo! (:new-todo-text @app-state)))}]
   [:button {:on-click #(create-todo! (:new-todo-text @app-state))}
    "Adicionar"]])

(defn todo-item [todo]
  [:li.todo-item {:class (when (= 1 (:completed todo)) "completed")}
   [:input.todo-checkbox
    {:type "checkbox"
     :checked (= 1 (:completed todo))
     :on-change #(toggle-todo! (:id todo))}]
   [:span.todo-text (:text todo)]
   [:button.delete-btn
    {:on-click #(delete-todo! (:id todo))}
    "Deletar"]])

(defn todo-list []
  (let [todos (:todos @app-state)]
    (if (empty? todos)
      [:div.empty-state "Nenhuma tarefa ainda. Adicione uma acima! 🎯"]
      [:ul.todo-list
       (for [todo todos]
         ^{:key (:id todo)}
         [todo-item todo])])))

(defn app []
  [:div.container
   [:h1 "📝 Minha Lista de Tarefas"]
   [todo-input]
   (if (:loading? @app-state)
     [:div.loading "Carregando..."]
     [todo-list])])

;; Inicialização
(defn init []
  (fetch-todos!)
  (rdom/render [app] (js/document.getElementById "app")))