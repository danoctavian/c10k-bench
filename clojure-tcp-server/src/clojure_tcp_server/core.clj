(ns clojure-tcp-server.core)

(require '[aleph.tcp :as tcp])
(require '[manifold.stream :as s])

(defn echo-handler [s info]
  (s/connect s s))

(defn -main
  "echo server"
  []
  (tcp/start-server echo-handler {:port 4000}))
