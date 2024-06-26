# Rounding Variants of numeric operations

The following instructions exist:

|prefix|opcode|name|
|----|-------|-------------------|
| | 0x91 |    f32.sqrt                               |
| | 0x92 |    f32.add                                |
| | 0x93 |    f32.sub                                |
| | 0x94 |    f32.mul                                |
| | 0x95 |    f32.div                                |
| | 0x9F |    f64.sqrt                               |
| | 0xA0 |    f64.add                                |
| | 0xA1 |    f64.sub                                |
| | 0xA2 |    f64.mul                                |
| | 0xA3 |    f64.div                                |
| | 0xA8 |    i32.trunc_f32_s                        |
| | 0xA9 |    i32.trunc_f32_u                        |
| | 0xAA |    i32.trunc_f64_s                        |
| | 0xAB |    i32.trunc_f64_u                        |
| | 0xAE |    i64.trunc_f32_s                        |
| | 0xAF |    i64.trunc_f32_u                        |
| | 0xB0 |    i64.trunc_f64_s                        |
| | 0xB1 |    i64.trunc_f64_u                        |
| | 0xB2 |    f32.convert_i32_s                      |
| | 0xB3 |    f32.convert_i32_u                      |
| | 0xB4 |    f32.convert_i64_s                      |
| | 0xB5 |    f32.convert_i64_u                      |
| | 0xB6 |    f32.demote_f64                         |
| | 0xB7 |    f64.convert_i32_s                      |
| | 0xB8 |    f64.convert_i32_u                      |
| | 0xB9 |    f64.convert_i64_s                      |
| | 0xBA |    f64.convert_i64_u                      |
| | 0xBB |    f64.promote_f32                        |

First of all, this proposal will not create new variants of the i32/i64.trunc_f32/f64_s/u instructions, which perform integer rounding. For now, corresponding gaps have been left in the opcode map which might be populated with such extensions later.

Otherwise, the above list entails the conversion-to/between floating points and the opertors `+-*/√` within the floats. Not every conversion or operation is excact. One has to round. In the existing instructions the closest neighbour is choosen. In case neither neighbour is closer to the exact result the one with an even mantissa is choosen.

There are other options for rounding namely:

|name|description|
|-----|-------|
|ceil|take the neighbour that is greater|
|floor|take the neighbour that is less|
|trunc|take the number that is closer to zero|

This proposal proposes to extend the matrix of floating point instructions by combining them with a new dimension called a rounding variant. But the first 4 instructions in the table below are for the purposes of branch preparation as concerns most the important use case, that being interval arithmetic. This results in the following new instructions:

|prefix|opcode|opcode binary|name                 | pretty string      |
|------|-------|--------------|----------------------|---------------------|
| 0xFC | 0x1C | 0b00011100 | f32.binary_sign         | binary_sign         |
| 0xFC | 0x1D | 0b00011101 | i32.trinary_sign_f32    | trinary_sign_f32    |
| 0xFC | 0x1E | 0b00011110 | f64.binary_sign         | binary_sign         |
| 0xFC | 0x1F | 0b00011111 | i32.trinary_sign_f64    | trinary_sign_f64    |
| 0xFC | 0x20 | 0b00100000 | f32.sqrt_ceil           | sqrt_ceil           |
| 0xFC | 0x21 | 0b00100001 | f32.add_ceil            | +_ceil              |
| 0xFC | 0x22 | 0b00100010 | f32.sub_ceil            | -_ceil              |
| 0xFC | 0x23 | 0b00100011 | f32.mul_ceil            | *_ceil              |
| 0xFC | 0x24 | 0b00100100 | f32.div_ceil            | /_ceil              |
| 0xFC | 0x25 | 0b00100101 | f64.sqrt_ceil           | sqrt_ceil           |
| 0xFC | 0x26 | 0b00100110 | f64.add_ceil            | +_ceil              |
| 0xFC | 0x27 | 0b00100111 | f64.sub_ceil            | -_ceil              |
| 0xFC | 0x28 | 0b00101000 | f64.mul_ceil            | *_ceil              |
| 0xFC | 0x29 | 0b00101001 | f64.div_ceil            | /_ceil              |
| 0xFC | 0x32 | 0b00110010 | f32.convert_i32_s_ceil  | convert_i32_s_ceil  |
| 0xFC | 0x33 | 0b00110011 | f32.convert_i32_u_ceil  | convert_i32_u_ceil  |
| 0xFC | 0x34 | 0b00110100 | f32.convert_i64_s_ceil  | convert_i64_s_ceil  |
| 0xFC | 0x35 | 0b00110101 | f32.convert_i64_u_ceil  | convert_i64_u_ceil  |
| 0xFC | 0x36 | 0b00110110 | f32.demote_f64_ceil     | demote_f64_ceil     |
| 0xFC | 0x37 | 0b00110111 | f64.convert_i32_s_ceil  | convert_i32_s_ceil  |
| 0xFC | 0x38 | 0b00111000 | f64.convert_i32_u_ceil  | convert_i32_u_ceil  |
| 0xFC | 0x39 | 0b00111001 | f64.convert_i64_s_ceil  | convert_i64_s_ceil  |
| 0xFC | 0x3A | 0b00111010 | f64.convert_i64_u_ceil  | convert_i64_u_ceil  |
| 0xFC | 0x3B | 0b00111011 | f64.promote_f32_ceil    | promote_f32_ceil    |
| 0xFC | 0x40 | 0b01000000 | f32.sqrt_floor          | sqrt_floor          |
| 0xFC | 0x41 | 0b01000001 | f32.add_floor           | +_floor             |
| 0xFC | 0x42 | 0b01000010 | f32.sub_floor           | -_floor             |
| 0xFC | 0x43 | 0b01000011 | f32.mul_floor           | *_floor             |
| 0xFC | 0x44 | 0b01000100 | f32.div_floor           | /_floor             |
| 0xFC | 0x45 | 0b01000101 | f64.sqrt_floor          | sqrt_floor          |
| 0xFC | 0x46 | 0b01000110 | f64.add_floor           | +_floor             |
| 0xFC | 0x47 | 0b01000111 | f64.sub_floor           | -_floor             |
| 0xFC | 0x48 | 0b01001000 | f64.mul_floor           | *_floor             |
| 0xFC | 0x49 | 0b01001001 | f64.div_floor           | /_floor             |
| 0xFC | 0x52 | 0b01010010 | f32.convert_i32_s_floor | convert_i32_s_floor |
| 0xFC | 0x53 | 0b01010011 | f32.convert_i32_u_floor | convert_i32_u_floor |
| 0xFC | 0x54 | 0b01010100 | f32.convert_i64_s_floor | convert_i64_s_floor |
| 0xFC | 0x55 | 0b01010101 | f32.convert_i64_u_floor | convert_i64_u_floor |
| 0xFC | 0x56 | 0b01010110 | f32.demote_f64_floor    | demote_f64_floor    |
| 0xFC | 0x57 | 0b01010111 | f64.convert_i32_s_floor | convert_i32_s_floor |
| 0xFC | 0x58 | 0b01011000 | f64.convert_i32_u_floor | convert_i32_u_floor |
| 0xFC | 0x59 | 0b01011001 | f64.convert_i64_s_floor | convert_i64_s_floor |
| 0xFC | 0x5A | 0b01011010 | f64.convert_i64_u_floor | convert_i64_u_floor |
| 0xFC | 0x5B | 0b01011011 | f64.promote_f32_floor   | promote_f32_floor   |
| 0xFC | 0x60 | 0b01100000 | f32.sqrt_trunc          | sqrt_trunc          |
| 0xFC | 0x61 | 0b01100001 | f32.add_trunc           | +_trunc             |
| 0xFC | 0x62 | 0b01100010 | f32.sub_trunc           | -_trunc             |
| 0xFC | 0x63 | 0b01100011 | f32.mul_trunc           | *_trunc             |
| 0xFC | 0x64 | 0b01100100 | f32.div_trunc           | /_trunc             |
| 0xFC | 0x65 | 0b01100101 | f64.sqrt_trunc          | sqrt_trunc          |
| 0xFC | 0x66 | 0b01100110 | f64.add_trunc           | +_trunc             |
| 0xFC | 0x67 | 0b01100111 | f64.sub_trunc           | -_trunc             |
| 0xFC | 0x68 | 0b01101000 | f64.mul_trunc           | *_trunc             |
| 0xFC | 0x69 | 0b01101001 | f64.div_trunc           | /_trunc             |
| 0xFC | 0x72 | 0b01110010 | f32.convert_i32_s_trunc | convert_i32_s_trunc |
| 0xFC | 0x73 | 0b01110011 | f32.convert_i32_u_trunc | convert_i32_u_trunc |
| 0xFC | 0x74 | 0b01110100 | f32.convert_i64_s_trunc | convert_i64_s_trunc |
| 0xFC | 0x75 | 0b01110101 | f32.convert_i64_u_trunc | convert_i64_u_trunc |
| 0xFC | 0x76 | 0b01110110 | f32.demote_f64_trunc    | demote_f64_trunc    |
| 0xFC | 0x77 | 0b01110111 | f64.convert_i32_s_trunc | convert_i32_s_trunc |
| 0xFC | 0x78 | 0b01111000 | f64.convert_i32_u_trunc | convert_i32_u_trunc |
| 0xFC | 0x79 | 0b01111001 | f64.convert_i64_s_trunc | convert_i64_s_trunc |
| 0xFC | 0x7A | 0b01111010 | f64.convert_i64_u_trunc | convert_i64_u_trunc |
| 0xFC | 0x7B | 0b01111011 | f64.promote_f32_trunc   | promote_f32_trunc   |

## Semantics

The semantics are specified by the IEEE standard and are as follows: For an instruction `O.f_I_round` with

| | |
| :---: | :--- |
| `O` | result type |
| `I` | input type |
| `f` | operator |
| `F` | corresponding exact mathematical function |
| `round` | rounding direction |

it is that:

| | | |
|----------------|-----|------------------------------------------------------|
| `O.f_I_ceil(x)`  | `=` | `min { y \| y ∈ O, F(x) <= y }`                       |
| `O.f_I_floor(x)` | `=` | `max { y \| y ∈ O, y <= F(x) }`                       |
| `O.f_I_trunc(x)` | `=` | `if 0 < F(x) then O.f_I_floor(x) else O.f_I_ceil(x)` |

This definition is not complete as the result might be zero and in that case the sign has to be determined. In that case IEEE defines the result as the usual sign rules (`+0.0` for `±`, `copysign(1,a*b) = copysign(1,a)*copysign(1,b)`) with following exception: Should `f` be `+` or `-` and the result be zero then the sign is `-`. In formal notation this gives us: (higher listed rules have precedence)


| | | |
| :------------- | :---: | :----------------------------------------------------------- |
| `O.±_I_floor(x)` |  `=`  |  `min (maximal { y \| y ∈ O, y <= F(x)      })`    |
| `O.±_I_ceil(x)`  |  `=`  |  `max (minimal { y \| y ∈ O,      F(x) <= y })`    |
| `O.f_I_ceil(x)`  |  `=`  |  `adapt_zero_signₓ { y \| y ∈ O,      F(x) <= y }`         |
| `O.f_I_floor(x)` |  `=`  |  `adapt_zero_signₓ { y \| y ∈ O, y <= F(x)      }`         |
| `O.f_I_trunc(x)` |  `=`  |  `if 0 < F(x) then O.f_I_floor(x) else O.f_I_ceil(x)`      |
| `adapt_zero_signₓ( {r} )` | `=` | `r` |
| `adapt_zero_signₓ( {-0.0,+0.0} )` | `=` | `copysign(0.0, x)` |
| `adapt_zero_sign₍ₗ,ᵣ₎( {-0.0,+0.0} )` | `=` | `copysign(0.0, copysign(1.0, l) * copysign(1.0, r))` |


Here `maximal` means a function that gives the set of maximal elements of the input set. So the result set is either a non zero number singleton or the set `{-0.0, 0.0}`. Here `max` and `min` are parameterized on the relation `<` with the additional having `-0.0 < 0.0` to make the relation total.

## Redundants

The following functions are redundant and simple to implement. For instance:
```
f32.convert_i32_s_ceil
f32.convert_i32_s_floor
f32.convert_i32_s_trunc
f32.convert_i32_u_ceil
f32.convert_i32_u_floor
f32.convert_i32_u_trunc
```
The functions above could be implemented by using `extend` on the input `i32` to yield a `i64`, followed by `f32.convert_i64_x_round`.



```
f32.convert_i64_s_ceil
f32.convert_i64_s_floor
f32.convert_i64_s_trunc
f32.convert_i64_u_ceil
f32.convert_i64_u_floor
f32.convert_i64_u_trunc
```
These `f32.convert_i64_x_round` functions could be implemented by utilizing `f64.convert_i64_x_round` and then using `f32.demote_f64_round` on the intermediate result. (Note that this doesn't always work with nearest-or-even rounding, but the "round" suffix does not comprehend that possibility.)



```
f64.convert_i32_s_ceil
f64.convert_i32_s_floor
f64.convert_i32_s_trunc
f64.convert_i32_u_ceil
f64.convert_i32_u_floor
f64.convert_i32_u_trunc
```
It turns out that the functions above are respectively equivalent to `f64.convert_i32_s` and `f64.convert_i32_u`. The reason is that an `f64` float contains a 53-bit mantissa, which is sufficient to accommodate an entire `i32`.




```
f64.promote_f32_ceil
f64.promote_f32_floor
f64.promote_f32_trunc
```
These are all equivalent to `f64.promote_f32` because such promotion would be lossless and therefore agnostic to rounding mode.



Technically the redundant functions do not add much normative value. But they are practical benefits of having them:

The operation and conversion tensor does not get arbitrary holes. This makes it easier to reason about the operations. The mathematical defenition of the semantic of `f64.promote_f32_ceil` is still different from `f64.promote_f32`. It is easier to express intend that way.

Having the full conversion tensor may improve portability of WebAssembly: With rounded instructions it is possible to write algorithms that are independent of and equivalent over different number formats. For example a user of the `wasm2c` tool could purposefully relax the requirement of `f32` to be IEEE floating point. The `c` standard does not require `flaot` to be IEEE. Lets say `f32` gets implemented by the plattform as `posit32`. `posit32` is a number format with more precicion around `1.0` than IEEE. That way there might be numbers in `float` that are not representable in `double`. Now you need a rounding variant of `promot` so that your iterating enclosing loop is still converging.

## performance

A user might expect performance improvement when avoiding 2 or 3 of the 4 rounding variants all together on certain hardware.
