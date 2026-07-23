# 🧮 Ready, Set, Boole!

**An introduction to Boolean Algebra**

Este repositorio sirve como manual interactivo para el proyecto *Ready, Set, Boole!* de 42. Al estar escrito en **Literate Haskell**, este archivo no solo se renderiza como documentación en GitHub, ¡sino que es código real que el compilador de Haskell puede ejecutar!

> Nota técnica: Para que Haskell lo compile, el código debe ir precedido por el símbolo `>`.

A medida que se resuelven los ejercicios, documentamos aquí su funcionamiento lógico y matemático.

---

## 📚 Índice de Funciones

1. [Adder (Suma a nivel de bits)](#1-adder-suma-a-nivel-de-bits)
2. [Multiplier (Multiplicación a nivel de bits)](#2-multiplier-multiplicación-a-nivel-de-bits)

---

> module Readme (adder, multiplier) where
> import Data.Word
> import Data.Bits

## 1. Adder (Suma a nivel de bits)

La suma de dos números enteros sin usar el operador matemático de suma se puede resolver utilizando operaciones a nivel de bits (*bitwise operations*). Para lograr esto, simulamos el comportamiento de un circuito sumador (*Half/Full Adder*).

### Lógica Matemática

En binario, la suma de dos bits se compone de dos partes:
1. **La suma parcial (sin acarreo):** Se obtiene mediante la compuerta lógica **XOR** ($\oplus$). Nos dice qué bits son diferentes.
2. **El acarreo (carry):** Solo ocurre cuando ambos bits son `1`, lo cual se detecta con una compuerta lógica **AND** ($\land$). Este acarreo debe moverse a la siguiente columna (una posición de mayor peso), lo que logramos con un **Shift Left** ($\ll$).

El proceso recursivo se repite hasta que ya no haya acarreo (es decir, cuando $b = 0$). Matemáticamente:

$$
S = a \oplus b
$$
$$
C = (a \land b) \ll 1
$$
$$
a + b = S + C
$$

### Implementación en Haskell

> adder :: Word32 -> Word32 -> Word32
> adder a 0 = a
> adder a b = adder (xor a b) $ shiftL (a .&. b) 1

---

## 2. Multiplier (Multiplicación a nivel de bits)

La multiplicación entera a nivel de bits suele simular el histórico algoritmo de la **multiplicación campesina rusa** (o de los antiguos egipcios). Este algoritmo transforma la multiplicación exclusivamente en desplazamientos de bits y sumas lógicas.

### Lógica Matemática

Para calcular $a \times b$, iteramos a través de los bits de $b$:
1. Analizamos el bit menos significativo de $b$ usando la operación **AND 1** ($b \land 1$).
2. Si el bit es `1`, se debe sumar el estado actual de $a$ a nuestro acumulador total (utilizando el `adder` del ejercicio anterior). Si es `0`, sumamos $0$.
3. Luego, desplazamos $a$ hacia la izquierda ($a \ll 1$), lo que equivale a duplicarlo matemáticamente.
4. Y desplazamos $b$ hacia la derecha ($b \gg 1$), descartando el bit que acabamos de leer.

Matemáticamente, la multiplicación descompone el número $b$ en potencias de 2:

$$
a \cdot b = \sum_{i=0}^{n} \left( a \cdot 2^i \right) \cdot (b_i)
$$

Donde $b_i$ representa el bit en la posición $i$ del número $b$.

### Implementación en Haskell

> multiplier :: Word32 -> Word32 -> Word32
> multiplier _ 0 = 0
> multiplier a 1 = a
> multiplier a b = adder (multiplier a $ b .&. 1) $ multiplier (shiftL a 1) (shiftR b 1)
