
(deffacts
(Modulo preguntas)
(Pregunta Hardware))

(deffacts Ramas
(Rama Computacion_y_Sistemas_Inteligentes)
(Rama Ingenieria_del_Software)
(Rama Sistemas_de_Informacion)
(Rama Tecnologias_de_la_Informacion)
(Rama Ingenieria_de_Computadores)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;; Modulo de preguntas ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; PREGUNTAS A REALIZAR
;; Primero preguntamos si le gustaría trabajar con hardware, ya que solo hay una rama orientada a esto
(defrule pregunta_hardware
(Modulo preguntas)
?f <- (Pregunta Hardware)
=>
(printout t " ¿Prefieres Hardware(H) o Software(S) o no sabes(NS)? " crlf)
(assert (Prefiere (read)))
(retract ?f)
(assert (Pregunta Programacion))
)

(defrule pregunta_programacion
(Modulo preguntas)
?f <- (Pregunta Programacion)
=>
(printout t "¿Te gusta programar? S/N/R (Si/No/Regular)" crlf)
(assert (GustaProgramar (read)))
(retract ?f)
(assert (Pregunta Matematicas))
)

;; Pregunta si le gusta las matemáticas
(defrule pregunta_matematicas
(Modulo preguntas)
?f <- (Pregunta Matematicas)
=>
(printout t "¿Cuál es tu nivel de matemáticas? Alto/Medio/Bajo" crlf)
(assert (NivelMatematicas (read)))
(retract ?f)
(assert (Pregunta Nota))
)

;; Pregunta la nota media
(defrule pregunta_nota_media
(Modulo preguntas)
?f <- (Pregunta Nota)
=>
(printout t "¿Cuál es tu nota media? " crlf)
(assert (NotaMedia (read)))
(retract ?f)
)

(defrule cambiar_modulo_preguntas
(declare (salience -10))
?modulo <- (Modulo preguntas)
=>
(retract ?modulo)
(assert (Modulo Inferencia Ignacio))
(assert (Modulo Inferencia Jacobo))
(assert (Modulo Inferencia Alejandro))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;; Modulo de inferencia ;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Cada uno da su respuesta con (Veredicto ?nombre ?rama ?explicacion)

;;;;;;;;;  Ignacio

;;;;;;;;;  Jacobo 

;;;;;;;;;  Alejandro


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;; Modulo de Respuesta ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule cambiar_modulo_respuestas
(declare (salience -10))
?modulo <- (Modulo preguntas)
(Veredicto Alejandro ?v1 ?e1)
(Veredicto Ignacio ?v2 ?e2)
(Veredicto Jacobo ?v3 ?e3)
=>
(retract ?modulo)
(assert (Modulo CalcularVeredictoFinal ?v1 ?e1 ?v2 ?e2 ?v3 ?e3))
)

(defrule calcular_mayoria_unanime
(salience 1)
?f <- (Modulo CalcularVeredictoFinal ?v1 ?e1 ?v2 ?e2 ?v3 ?e3)
(and (eq ?v1 ?v2) (eq ?v1 ?v3))
=>
(mayoria_unanime ?v1 ?e1 ?e2 ?e3)
(retract ?f)
(assert (Modulo Respuesta))
)

(defrule calcular_mayoria_v1_v2
(Modulo CalcularVeredictoFinal ?v1 ?e1 ?v2 ?e2 ?v3 ?e3)
(test (eq ?v1 ?v2))
=>
(mayoria ?v1 ?e1 ?e2)
)

(defrule calcular_mayoria_v1_v3
(Modulo CalcularVeredictoFinal ?v1 ?e1 ?v2 ?e2 ?v3 ?e3)
(test (eq ?v1 ?v3))
=>
(mayoria ?v1 ?e1 ?e3)
)

(defrule calcular_mayoria_v2_v3
(Modulo CalcularVeredictoFinal ?v1 ?e1 ?v2 ?e2 ?v3 ?e3)
(test (eq ?v2 ?v3))
=>
(mayoria ?v2 ?e2 ?e3)
)

(defrule calcular_veredicto_final
?modulo <- (Modulo CalcularVeredictoFinal ?v1 ?v2 ?v3)

)