%Base de conocimiento
opcionHoraria(paradigmas, lunes).
opcionHoraria(paradigmas, martes).
opcionHoraria(paradigmas, sabados).
opcionHoraria(algebra, lunes).

%Correlatividades
correlativa(paradigmas, algoritmos).
correlativa(paradigmas, algebra).
correlativa(analisis2, analisis1).


%cursada(persona,materia,evaluaciones).
cursada(maria,algoritmos,[parcial(5),parcial(7),tp(mundial,bien)]).
cursada(maria,algebra,[parcial(5),parcial(8),tp(geometria,excelente)]).
cursada(maria,analisis1,[parcial(9),parcial(4),tp(gauss,bien), tp(limite,mal)]).
cursada(wilfredo,paradigmas,[parcial(7),parcial(7),parcial(7),tp(objetos,excelente),tp(logico,excelente),tp(funcional,excelente)]).
cursada(wilfredo,analisis2,[parcial(8),parcial(10)]).

%Punto 1:
notaFinal(Evaluaciones, NotaFinal):-
    findall(Nota, notaEvaluacion(Evaluaciones, Nota), Notas),
    sum_list(Notas, NotaFinalTotal),
    length(Evaluaciones, CantidadNotas),
    NotaFinal is NotaFinalTotal/CantidadNotas.

notaEvaluacion(Evaluaciones, Nota):-
    member(Evaluacion, Evaluaciones),
    notaDeEvaluacion(Evaluacion, Nota).

notaDeEvaluacion(parcial(Nota), Nota).
notaDeEvaluacion(tp(_,NotaTp), Nota):-
    notaTp(NotaTp, Nota).

notaTp(excelente, 10).
notaTp(bien, 7).
notaTp(mal,2).

%Punto 2:
aprobo(Persona, Materia):-
    cursada(Persona,Materia, Evaluaciones),
    aproboCursada(Evaluaciones),
    not(reproboEvaluacion(Evaluaciones)).

aproboCursada(Evaluaciones):-
    notaFinal(Evaluaciones, NotaFinal),
    NotaFinal >= 4.

reproboEvaluacion(Evaluaciones):-
    notaEvaluacion(Evaluaciones, Nota),
    Nota < 4.

%Punto 3:
puedeCursar(Persona, MateriaCursable):-
    cursada(_,MateriaCursable,_),
    aproboTodasLasCorrelativas(Persona, MateriaCursable),
    not(aproboMateriaOCorrelativaSuperior(Persona, MateriaCursable)).
    

aproboTodasLasCorrelativas(Persona, Materia):-
    cursada(Persona,_,_),
    forall(correlativa(Materia,Correlativa), aprobo(Persona, Correlativa)).


aproboMateriaOCorrelativaSuperior(Persona, MateriaCursable):-
    materiaOCorrelativaSuperior(MateriaCursable, OtraMateria),
    aprobo(Persona, OtraMateria).

materiaOCorrelativaSuperior(Materia, Materia).
materiaOCorrelativaSuperior(Materia, CorrelativaSuperior):-
    correlativa(CorrelativaSuperior, Materia).

