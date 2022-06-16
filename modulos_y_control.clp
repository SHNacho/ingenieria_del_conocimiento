
(deffacts Inicio
(Modulo preguntas)
(Pregunta Hardware)
)

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

;;; Comprueba que la respuesta es correcta. Si no, la vuelve a responder. ;;;
(defrule comprobar_hardware
(declare (salience 999))
?f <- (Prefiere ?hs)
(test (and (neq ?hs H) (neq ?hs S) (neq ?hs NS)))
=>
(printout t "Tienes que contestar H si prefieres Hardware, S si es software o NS si no lo sabes o te da igual una que otra. " crlf)
(retract ?f)
(assert (Pregunta Hardware))
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

;;; Comprueba que la respuesta es correcta. Si no, la vuelve a responder. ;;;
(defrule comprobar_programacion
(declare (salience 999))
?f <- (GustaProgramar ?r)
(test (and (neq ?r S) (neq ?r N) (neq ?r R)))
=>
(printout t "Tienes que contestar S si te gusta programar, N si no te gusta y R si ni mucho ni poco, o te da igual. " crlf)
(retract ?f)
(assert (Pregunta Programacion))
)

;; Pregunta si le gusta las matemáticas
(defrule pregunta_matematicas
(Modulo preguntas)
?f <- (Pregunta Matematicas)
=>
(printout t "¿Cuál es tu nivel de matemáticas? Bajo/Medio/Alto" crlf)
(assert (NivelMatematicas (read)))
(retract ?f)
(assert (Pregunta Nota))
)

;;; Comprueba que la respuesta es correcta. Si no, la vuelve a responder. ;;;
(defrule comprobar_matematicas
(declare (salience 999))
?f <- (NivelMatematicas ?r)
(test (and (neq ?r Alto) (neq ?r Medio) (neq ?r Bajo)))
=>
(printout t " Tienes que decirme tu nivel de matemáticas o tu gusto por ellas, en una escala Bajo / Medio / Alto. " crlf)
(retract ?f)
(assert (Pregunta Matematicas))
)

;; Pregunta la nota media
(defrule pregunta_nota_media
(Modulo preguntas)
?f <- (Pregunta Nota)
=>
(printout t "¿Cuál es tu nota media? Debe de ser un número del 1 al 10 " crlf)
(assert (NotaMedia (read)))
(retract ?f)
)

;;; Comprueba que la respuesta es correcta. Si no, la vuelve a responder. ;;;
(defrule comprobar_nota_media
?f <- (NotaMedia ?nota)
(test (or (< ?nota 5) (> ?nota 10)))
=>
(printout t "La nota media es incorrecta. Es un valor del 5 al 10. Te lo volveré a preguntar" crlf)
(retract ?f)
(assert (Pregunta Nota))
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; PASAR DE NOTA NUMÉRICA A CATEGÓRICA ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule calcular_nota_media_baja
(NotaMedia ?nota)
(test (and (< ?nota 6) (>= ?nota 5)))
=>
(assert (Nota_mediaDeducida BAJA))
)

(defrule calcular_nota_media_media
(NotaMedia ?nota)
(test (and (>= ?nota 6) (< ?nota 8)))
=>
(assert (NotaMediaDeducida MEDIA))
)

(defrule calcular_nota_media_alta
(NotaMedia ?nota)
(test (>= ?nota 8))
=>
(assert (NotaMediaDeducida ALTA))
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


;;; Si el usuario no sabe si es trabajador o no, se le hace una pregunta un poco más práctica donde se le pregunta su grado de dedicación por las asignaturas de la carrera. ;;;
(defrule inferir_es_trabajador
?f <- (Es_trabajador NS)
=>
(printout t "Entiendo, no lo sabes. Y, del 1 al 10, ¿cuál es tu grado de compromiso con las asignaturas que has cursado? Siendo un 10 el máximo, claro: " crlf)
(retract ?f)
(assert (Inferir_trabajador (read)))
)

(defrule inferir_no_es_trabajador
(Inferir_trabajador ?nota)
(test (< ?nota 6))
=>
(assert (Es_trabajador NO))
)

(defrule inferir_si_es_trabajador
(Inferir_trabajador ?nota)
(test (>= ?nota 6))
=>
(assert (Es_trabajador SI))
)


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
(assert (mayoria_unanime ?v1 ?e1 ?e2 ?e3))
(retract ?f)
(assert (Modulo Respuesta))
)

(defrule calcular_mayoria_v1_v2
(Modulo CalcularVeredictoFinal ?v1 ?e1 ?v2 ?e2 ?v3 ?e3)
(test (eq ?v1 ?v2))
=>
(assert (mayoria ?v1 ?e1 ?e2))
)

(defrule calcular_mayoria_v1_v3
(Modulo CalcularVeredictoFinal ?v1 ?e1 ?v2 ?e2 ?v3 ?e3)
(test (eq ?v1 ?v3))
=>
(assert (mayoria ?v1 ?e1 ?e3))
)

(defrule calcular_mayoria_v2_v3
(Modulo CalcularVeredictoFinal ?v1 ?e1 ?v2 ?e2 ?v3 ?e3)
(test (eq ?v2 ?v3))
=>
(assert (mayoria ?v2 ?e2 ?e3))
)

;; (defrule calcular_veredicto_final
;; ?modulo <- (Modulo CalcularVeredictoFinal ?v1 ?v2 ?v3)

;;)