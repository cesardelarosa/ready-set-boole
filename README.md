# Ready, Set, Boole!

> An introduction to Boolean Algebra — 42 Project by cde-la-r

A Haskell library and CLI tool implementing Boolean Algebra, Set Theory and Space-Filling Curves from first principles, using only bitwise operations where required.

---

## Build & Run

```bash
# Build everything (library + app + tests)
cabal build

# Run the CLI
cabal run ready-set-boole-app -- <command> [args...]

# Run the property-based test suite
cabal test
```

### Shell quoting

Some formula characters (`&`, `|`, `>`) are special in your shell. **Always wrap formulas in quotes**:

```bash
# Wrong — the shell interprets & as "run in background"
cabal run . -- evalformula 10&

# Correct
cabal run . -- evalformula '10&'
```

---

## Commands

```
[Bitwise]
  adder <num1> <num2>
  multiplier <num1> <num2>
  graycode <num>

[Boolean]
  evalformula "<formula>"
  printtruthtable "<formula>"
  nnf "<formula>"
  cnf "<formula>"
  sat "<formula>"

[Sets]
  powerset "[num1, num2,...]"
  evalset "<formula>" "[[num1,num2], [num3]]"

[Curves]
  map <num1> <num2>
  fnreversemap <double>
```

---

## RPN — Reverse Polish Notation

> **Quick reminder:** In [Reverse Polish Notation](https://en.wikipedia.org/wiki/Reverse_Polish_notation) (postfix notation), operators come **after** their operands. A stack is used: push operands, pop when you see an operator.

| Infix | RPN |
|---|---|
| $A \land B$ | `AB&` |
| $(A \lor B) \land C$ | `AB\|C&` |
| $\neg(A \land B)$ | `AB&!` |

Symbol table shared across all Boolean/Set exercises:

| Symbol | Math | Meaning |
|---|---|---|
| `0` / `1` | $\perp$ / $\top$ | False / True |
| `A`…`Z` | $A\ldots Z$ | Variable / Set |
| `!` | $\neg$ | Negation |
| `&` | $\land$ | Conjunction (AND) |
| `\|` | $\lor$ | Disjunction (OR) |
| `^` | $\oplus$ | Exclusive OR (XOR) |
| `>` | $\Rightarrow$ | Material implication |
| `=` | $\iff$ | Logical equivalence |

---

## Functions

### Bitwise — `src/Bitwise.hs`

#### `adder`

Adds two `Word32` values using **only bitwise operations** — no `+`.

```bash
cabal run . -- adder 3 4   # 7
```

XOR gives the sum without carry; AND + left-shift gives the carry. Repeat until carry is zero:

$$
a + b = (a \oplus b) + ((a \land b) \ll 1)
$$

Complexity: $O(\log n)$.

---

#### `multiplier`

Multiplies two `Word32` values using **only bitwise operations** — no `*`.

```bash
cabal run . -- multiplier 6 7   # 42
```

[Binary multiplication](https://en.wikipedia.org/wiki/Binary_multiplier): if the lowest bit of `b` is set, add `a` to the accumulator; shift `a` left and `b` right, repeat.

$$
a \times b = \sum_{i} a \cdot b_i \cdot 2^i \quad \text{where } b_i \in \{0,1\}
$$

Complexity: $O(1)$ — fixed 32 iterations.

---

#### `grayCode`

Converts a natural number to its [Gray code](https://en.wikipedia.org/wiki/Gray_code) equivalent.

```bash
cabal run . -- graycode 4   # 6
```

A Gray code is a binary encoding where **consecutive values differ by exactly 1 bit**, avoiding glitches in hardware counters. Formula:

$$
G(n) = n \oplus (n \gg 1)
$$

| n | binary | Gray |
|---|---|---|
| 0 | 000 | 000 |
| 1 | 001 | 001 |
| 2 | 010 | 011 |
| 3 | 011 | 010 |
| 4 | 100 | 110 |

---

### Boolean — `src/Boolean.hs`

#### `evalFormula`

Evaluates a closed RPN formula (only `0`/`1`, no variables).

```bash
cabal run . -- evalformula '10&'   # False
cabal run . -- evalformula '10|'   # True
cabal run . -- evalformula '11>'   # True
cabal run . -- evalformula '10='   # False
```

Returns `Right Bool` or `Left String` with a descriptive error. Stack machine — $O(n)$.

> **Implication:** $A \Rightarrow B$ is false **only** when $A$ is true and $B$ is false. Equivalently: $A \Rightarrow B \iff \neg A \lor B$.

---

#### `printTruthTable`

Prints the complete truth table for a formula with variables `A`…`Z`.

```bash
cabal run . -- printtruthtable 'AB&C|'
```

Output for $(A \land B) \lor C$:

```text
| A | B | C | = |
|---|---|---|---|
| 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 |
...
| 1 | 1 | 1 | 1 |
```

For $n$ variables: $2^n$ rows — $O(2^n)$.

---

#### `negationNormalForm` (NNF)

Rewrites a formula into [Negation Normal Form](https://en.wikipedia.org/wiki/Negation_normal_form): negations pushed inward until they sit directly next to variables. Output uses only `!`, `&`, `|`.

```bash
cabal run . -- nnf 'AB&!'   # A!B!|
cabal run . -- nnf 'AB>'    # A!B|
```

Rewrite rules applied exhaustively:

| Rule | Transformation |
|---|---|
| Double negation | $\neg\neg A \iff A$ |
| De Morgan (AND) | $\neg(A \land B) \iff \neg A \lor \neg B$ |
| De Morgan (OR) | $\neg(A \lor B) \iff \neg A \land \neg B$ |
| Implication | $A \Rightarrow B \iff \neg A \lor B$ |
| Equivalence | $A \iff B \equiv (A \Rightarrow B) \land (B \Rightarrow A)$ |

---

#### `conjunctiveNormalForm` (CNF)

Rewrites a formula into [Conjunctive Normal Form](https://en.wikipedia.org/wiki/Conjunctive_normal_form): a conjunction (`&`) of disjunction clauses, with all `&` at the outermost level.

```bash
cabal run . -- cnf 'AB&!'     # A!B!|
cabal run . -- cnf 'AB|C&'    # AB|C&
```

Strategy: compute NNF first, then distribute `|` over `&`:

$$
A \lor (B \land C) \iff (A \lor B) \land (A \lor C)
$$

> Output can grow **exponentially** in the worst case. Tseitin-based algorithms avoid this but are not required.

---

#### `sat`

Determines whether a formula is [satisfiable](https://en.wikipedia.org/wiki/Boolean_satisfiability_problem): is there at least one variable assignment that makes it `True`?

```bash
cabal run . -- sat 'AB|'    # True
cabal run . -- sat 'AA!&'   # False  (always False)
cabal run . -- sat 'AA^'    # False  (A XOR A is always False)
```

Brute-force: enumerate all $2^n$ combinations — $O(2^n)$. SAT is NP-complete in general.

---

### Sets — `src/Sets.hs`

#### `powerset`

Returns the [power set](https://en.wikipedia.org/wiki/Power_set) P(A): the set of **all subsets** of A, including ∅ and A itself.

```bash
cabal run . -- powerset '[1,2,3]'
# [[],[1],[2],[1,2],[3],[1,3],[2,3],[1,2,3]]
```

$$
\mathcal{P}(\{1,2\}) = \{\emptyset, \{1\}, \{2\}, \{1,2\}\}
$$

If $|A| = n$ then $|\mathcal{P}(A)| = 2^n$ — space complexity $O(2^n)$.

---

#### `evalSet`

Evaluates a propositional RPN formula over **sets** instead of booleans. Logical operations become set operations:

```bash
cabal run . -- evalset 'AB&' '[[0,1,2],[0,3,4]]'   # [0]            (intersection)
cabal run . -- evalset 'AB|' '[[0,1,2],[3,4,5]]'   # [0,1,2,3,4,5]  (union)
cabal run . -- evalset 'A!'  '[[0,1,2]]'           # []             (complement)
```

| Logic | Set Theory |
|---|---|
| $\neg A$ | $A^\complement$ (complement w.r.t. universe) |
| $A \lor B$ | $A \cup B$ (union) |
| $A \land B$ | $A \cap B$ (intersection) |

The universe is defined as the union of all provided sets.

---

### Curves — `src/Curves.hs`

> Optional exercises (Ex10 & Ex11).

#### `map`

Maps a 2D coordinate $(x, y) \in [0,\, 2^{16}-1]^2$ to a unique value in $[0, 1] \subset \mathbb{R}$ using a [space-filling curve](https://en.wikipedia.org/wiki/Space-filling_curve) — specifically the [Z-order / Morton curve](https://en.wikipedia.org/wiki/Z-order_curve).

```bash
cabal run . -- map 128 256
```

$$
f : \mathbb{N}^2 \to [0,1] \subset \mathbb{R}, \quad f \text{ bijective}
$$

Interleaves the bits of `x` and `y` into a Morton code, normalised to `[0,1]`. Used in GPUs to improve texture cache locality.

---

#### `fnReverseMap`

The inverse of `map`: recovers the original $(x, y)$ from $n \in [0, 1]$.

```bash
cabal run . -- fnreversemap 0.5
```

$$
f^{-1} : [0,1] \to \mathbb{N}^2, \quad (f^{-1} \circ f)(x,y) = (x,y)
$$

Deinterleaves the bits of the Morton code to recover the original coordinates.

---

## Testing

Property-based tests in [`test/Spec.hs`](test/Spec.hs) use [QuickCheck](https://hackage.haskell.org/package/QuickCheck).

```bash
cabal test
```

| Function | Property |
|---|---|
| `adder a b` | `adder a b === a + b` |
| `multiplier a b` | `multiplier a b === a * b` |
| `grayCode n` | `popCount (grayCode n XOR grayCode (n-1)) === 1` |
| `negationNormalForm f` | semantic equivalence under all variable assignments |
| `conjunctiveNormalForm f` | semantic equivalence under all variable assignments |
| `sat f` | cross-check against truth table enumeration |
| `powerset s` | `length (powerset s) === 2 ^ length s` |
| `map` / `fnReverseMap` | `fnReverseMap (map x y) === (x, y)` |

---

## Project Structure

```
ready-set-boole/
├── app/
│   └── Main.hs          — CLI entry point (all 12 commands)
├── src/
│   ├── Bitwise.hs       — Ex00-02: adder, multiplier, grayCode
│   ├── Boolean.hs       — Ex03-07: evalFormula, printTruthTable, NNF, CNF, SAT
│   ├── Sets.hs          — Ex08-09: powerset, evalSet
│   └── Curves.hs        — Ex10-11: map, fnReverseMap
├── test/
│   └── Spec.hs          — QuickCheck property tests
└── ready-set-boole.cabal
```

---

## References

- [Boolean algebra — Wikipedia](https://en.wikipedia.org/wiki/Boolean_algebra)
- [Reverse Polish Notation — Wikipedia](https://en.wikipedia.org/wiki/Reverse_Polish_notation)
- [Gray code — Wikipedia](https://en.wikipedia.org/wiki/Gray_code)
- [Negation Normal Form — Wikipedia](https://en.wikipedia.org/wiki/Negation_normal_form)
- [Conjunctive Normal Form — Wikipedia](https://en.wikipedia.org/wiki/Conjunctive_normal_form)
- [Boolean satisfiability — Wikipedia](https://en.wikipedia.org/wiki/Boolean_satisfiability_problem)
- [Power set — Wikipedia](https://en.wikipedia.org/wiki/Power_set)
- [Space-filling curve — Wikipedia](https://en.wikipedia.org/wiki/Space-filling_curve)
- [Z-order (Morton) curve — Wikipedia](https://en.wikipedia.org/wiki/Z-order_curve)
- [QuickCheck — Hackage](https://hackage.haskell.org/package/QuickCheck)
