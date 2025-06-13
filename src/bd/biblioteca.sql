CREATE TABLE IF NOT EXISTS alumno (
  id SERIAL PRIMARY KEY,
  nombres VARCHAR(100) NOT NULL,
  apellidos VARCHAR(100) NOT NULL,
  carrera VARCHAR(100) NOT NULL
);


CREATE TABLE IF NOT EXISTS libro (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(200) NOT NULL,
  editorial VARCHAR(100) NOT NULL,
  dias_limite_prestamo INTEGER NOT NULL
);


CREATE TABLE IF NOT EXISTS prestamo (
  id SERIAL PRIMARY KEY,
  id_alumno INTEGER NOT NULL
    REFERENCES alumno(id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  id_libro INTEGER NOT NULL
    REFERENCES libro(id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  fecha_prestamo DATE NOT NULL,
  entregado BOOLEAN NOT NULL DEFAULT FALSE
);

SELECT 
  l.nombre, -- Nombre del libro que se ha prestado
  p.fecha_prestamo, -- Fecha que se prestó el libro
  (p.fecha_prestamo -- Fecha de vencimiento del préstamo
     + (l.dias_limite_prestamo * INTERVAL '1 day')
  ) AS fecha_limite
FROM alumno a
JOIN prestamo p ON p.id_alumno = a.id
JOIN libro l   ON p.id_libro   = l.id
WHERE a.id           = 3
  AND p.entregado    = FALSE
  AND (p.fecha_prestamo
       + (l.dias_limite_prestamo * INTERVAL '1 day')
      ) < '2021-07-30'::DATE;