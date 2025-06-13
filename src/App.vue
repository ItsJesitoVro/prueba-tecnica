<script setup>
import {ref} from 'vue'

const mostrarCadenaInvertida = ref(false)
const mostrarArregloParesUnicos = ref(false)
const mostrarNumerosPrimosGemelos = ref(false)
const mostrarConjugacion = ref(false)
const mostrarExplicacionSql = ref(false)
const cadena = ref('')
const resultado = ref('')

const arregloNumeros = ref('')
const resultadoParesUnicos = ref([])

const numeroInicial = ref('');
const numeroFinal = ref('');
const resultadoPrimosGemelos = ref([]);
const primosGemelosProcesados = ref(false);

const arregloConjugacion = ref('');
const objetivoConjugacion = ref('');
const resultadoConjugacion = ref(null);

function invertirCadena() {
  resultado.value = cadena.value.replace(/\S+/g, word =>
      [...word].reverse().join('')
  );
//   Aqui se pueden usar 2 maneras de invertir la cadena, la opción uno es por regex, la implementé porque es mas corta y optima,
//   la segunda opción es usar unicamente los métodos reverse con join y split, es mas fácil de entender pero consume mas recursos de memoria.
}

function obtenerParesUnicos() {
  const paresUnicos = new Set();
  arregloNumeros.value
      .split(',')
      .forEach(valorBruto => {
        const numero = parseInt(valorBruto.trim(), 10);
        if (!isNaN(numero) && numero % 2 === 0) {
          paresUnicos.add(numero);
        }
      });
  resultadoParesUnicos.value = Array.from(paresUnicos).sort((a, b) => a - b);
}

function esPrimo(numero) {
  if (numero < 2) return false;
  for (let primo = 2; primo <= Math.sqrt(numero); primo++) {
    if (numero % primo === 0) return false;
  }
  return true;
  // Esta función se puede optimizar, se puede guardar en cache los números que ya se han calculado en un Map.
}

function agregarSeparador() {
  if (arregloNumeros.value.slice(-1) !== ',') {
    arregloNumeros.value += ',';
  } else if (arregloConjugacion.value.slice(-1) !== ',') {
    arregloConjugacion.value += ',';
  }
  // Esta función se puede separar para que solo aplique de manera individual a cada input, los junte para poder reutilizar la función en ambos inputs.
}

function formatoEntrada() {
  arregloNumeros.value = arregloNumeros.value.replace(/[^0-9,]/g, '');
  arregloConjugacion.value = arregloConjugacion.value.replace(/[^0-9,]/g, '');
  // Esta función se puede separar para que solo aplique de manera individual a cada input, los junte para poder reutilizar la función en ambos inputs.
}

function obtenerPrimosGemelos() {
  primosGemelosProcesados.value = true;
  const inicio = parseInt(numeroInicial.value, 10);
  const final = parseInt(numeroFinal.value, 10);
  const primos = [];
  for (let numero = inicio; numero <= final; numero++) {
    if (esPrimo(numero)) primos.push(numero);
  }
  resultadoPrimosGemelos.value = primos
      .filter(primo => esPrimo(primo + 2) && primo + 2 <= final)
      .map(primo => [primo, primo + 2]);
}

function comprobarComposicion(arreglo, maximo) {
  const arregloUnico = Array.from(new Set(arreglo));
  // Agregue un areglo de dinamico de booleanos para evitar el uso de Set y asi mejorando rendimiento.
  const arregloDinamico = new Array(maximo + 1).fill(false);
  arregloDinamico[0] = true;

  for (const numero of arregloUnico) {
    for (let sumaActual = maximo; sumaActual >= numero; sumaActual--) {
      if (arregloDinamico[sumaActual - numero]) {
        arregloDinamico[sumaActual] = true;
      }
    }
    if (arregloDinamico[maximo]) return true;
  }
  return arregloDinamico[maximo];
}

function procesarConjugacion() {
  const arreglo = arregloConjugacion.value
      .split(',')
      .map(dato => parseInt(dato.trim(), 10))
      .filter(n => !isNaN(n));
  const resultado = parseInt(objetivoConjugacion.value, 10);
  resultadoConjugacion.value = comprobarComposicion(arreglo, resultado);
  // En esta función si se permitiera agregar valores negativos, se podria agregar una validación la cual no lea los números negativos y asi optimizar la memoria.
}

// Esta función la cree para limpiar los inputs y resultados de las funciones de manera global.
function limpiarFunciones() {
  mostrarCadenaInvertida.value = false;
  mostrarArregloParesUnicos.value = false;
  mostrarNumerosPrimosGemelos.value = false;
  mostrarConjugacion.value = false;
  mostrarExplicacionSql.value = false;
  cadena.value = '';
  resultado.value = '';
  arregloNumeros.value = '';
  resultadoParesUnicos.value = [];
  numeroInicial.value = '';
  numeroFinal.value = '';
  resultadoPrimosGemelos.value = [];
  primosGemelosProcesados.value = false;
  arregloConjugacion.value = '';
  objetivoConjugacion.value = '';
  resultadoConjugacion.value = null;
}
</script>

<template>
  <header>
    <h1>Demo de Funciones</h1>
    <p>Selecciona la función que deseas probar</p>
  </header>

  <div>
    <button class="boton-funciones" @click="limpiarFunciones(); mostrarCadenaInvertida = true">
      Cadena Inversa
    </button>
    <button class="boton-funciones" @click="limpiarFunciones(); mostrarArregloParesUnicos = true">
      Pares Únicos
    </button>
    <button class="boton-funciones" @click="limpiarFunciones(); mostrarNumerosPrimosGemelos = true">
      Retorno de Números Primos Gemelos
    </button>
    <button class="boton-funciones" @click="limpiarFunciones(); mostrarConjugacion = true">
      Composición de la Conjugación
    </button>
    <button class="boton-funciones" @click="limpiarFunciones(); mostrarExplicacionSql = true">
      Biblioteca
    </button>
  </div>

  <!--  Función para invertir una cadena de texto-->
  <div v-if="mostrarCadenaInvertida">
    <div>Ingresa la cadena que deseas invertir</div>
    <input class="input-texto" v-model="cadena" placeholder="Ingresa la cadena"/>
    <button class="estilo-boton" @click="invertirCadena()" :disabled="!cadena">Invertir</button>
    <p v-if="resultado">Resultado: {{ resultado }}</p>
  </div>

  <!--  Función para obtener los números pares únicos de un arreglo-->
  <div v-if="mostrarArregloParesUnicos">
    <div>Ingresa el arreglo de números</div>
    <input
        class="input-texto"
        v-model="arregloNumeros"
        placeholder="Ingresa los números"
        @keydown.enter.prevent="agregarSeparador"
        @keydown.space.prevent="agregarSeparador"
        @input="formatoEntrada"
    />
    <button class="estilo-boton" @click="obtenerParesUnicos()" :disabled="!arregloNumeros.trim()">
      Procesar Pares Únicos
    </button>
    <p v-if="resultadoParesUnicos.length">
      Resultado: {{ resultadoParesUnicos.join(', ') }}
    </p>
  </div>

  <!--  Función para obtener los números primos gemelos-->
  <div class="contenedor-primos" v-if="mostrarNumerosPrimosGemelos">
    <div>
      <div>Ingresa el rango Inicial</div>
      <input
          type="number"
          min="0"
          class="input-numero"
          v-model="numeroInicial"
          placeholder="Inicio del rango"
      />
    </div>
    <div>
      <div>Ingresa el rango Inicial</div>
      <input
          type="number"
          min="0"
          class="input-numero"
          v-model="numeroFinal"
          placeholder="Fin del rango"
      />
    </div>

    <button class="estilo-boton" @click="obtenerPrimosGemelos()" :disabled="!numeroInicial || !numeroFinal">
      Procesar Primos Gemelos
    </button>
    <p v-if="resultadoPrimosGemelos.length">
      Resultado: {{ resultadoPrimosGemelos.map(pair => '(' + pair[0] + ', ' + pair[1] + ')').join(', ') }}
    </p>
    <p v-else-if="primosGemelosProcesados">
      No hay primos gemelos en el rango {{ numeroInicial }} al {{ numeroFinal }}
    </p>
  </div>

  <!--  Función para Composición de la Conjugación -->
  <div v-if="mostrarConjugacion">
    <div>Ingresa el arreglo de números</div>
    <input
        class="input-texto"
        v-model="arregloConjugacion"
        @keydown.enter.prevent="agregarSeparador"
        @keydown.space.prevent="agregarSeparador"
        @input="formatoEntrada"
        placeholder="Ingresa los números"
    />
    <div>Ingresa el valor objetivo</div>
    <input
        type="number"
        class="input-numero"
        v-model="objetivoConjugacion"
        placeholder="Ingresa el objetivo"
    />
    <button
        class="estilo-boton"
        @click="procesarConjugacion()"
        :disabled="!arregloConjugacion.trim() || !objetivoConjugacion">
      Comprobar Composición
    </button>
    <p v-if="resultadoConjugacion !== null">
      Resultado: {{ resultadoConjugacion ? 'TRUE' : 'FALSE' }}
    </p>
  </div>

  <div v-if="mostrarExplicacionSql">
    <h2>Explicacion del Query</h2>
    <p>
      SELECT
      l.nombre,
      p.fecha_prestamo,
      (p.fecha_prestamo
      + (l.dias_limite_prestamo * INTERVAL '1 day')
      ) AS fecha_limite
      FROM alumno a
      JOIN prestamo p ON p.id_alumno = a.id
      JOIN libro l ON p.id_libro = l.id
      WHERE a.id = 3
      AND p.entregado = FALSE
      AND (p.fecha_prestamo
      + (l.dias_limite_prestamo * INTERVAL '1 day')
      ) < '2021-07-30'::DATE;
    </p>
    <div>Explicacion</div>
    <div>
      El select solo va a tomar el nombre de la persona que debe el libro, la fecha que se presto dicho libro y
      finalmente se hace un calculo de la fecha limite del libre para saber que dia era el que tenia que entregarse
      va hacer una relacion del alumno, prestamo y el libro para obtener su relacion con el alumno de ID=3 y que no
      hayan sido entrgados, el uso de INTERVAL es para poder calcular por dias y manejar correctamente el tipo DATE
      en postgresql.
    </div>
  </div>

</template>

<style scoped>
header {
  line-height: 1.5;
}

h1 {
  padding: 25px 0;
}

p {
  padding: 15px 0;
}

.input-texto {
  width: 100%;
  border-radius: 6px;
  padding: 8px;
  margin: 10px 0;
}

.input-numero {
  width: 20%;
  border-radius: 6px;
  padding: 8px;
  margin: 10px;
}

.estilo-boton {
  background-color: mediumpurple;
  color: white;
  padding: 10px 20px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}

.estilo-boton:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  background-color: gray;
}

.boton-funciones {
  background-color: deepskyblue;
  color: white;
  padding: 10px 20px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  margin: 0 10px 10px;
}

.contenedor-primos {
  display: flex;
  flex-direction: column;
  flex-wrap: wrap;
}
</style>
