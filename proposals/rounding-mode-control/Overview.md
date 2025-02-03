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

This proposal proposes to extend the matrix of floating point instructions by combining them with a new dimension called a rounding variant. This results in the following new instructions:

|prefix|opcode| binary      | name                    | pretty string       |
|------|------|-------------|-------------------------|---------------------|
| 0xFC | 0x80 | 0b1'0000000 | f32.sqrt_ceil           | sqrt_ceil           |
| 0xFC | 0x81 | 0b1'0000001 | f32.add_ceil            | +_ceil              |
| 0xFC | 0x82 | 0b1'0000010 | f32.sub_ceil            | -_ceil              |
| 0xFC | 0x83 | 0b1'0000011 | f32.mul_ceil            | *_ceil              |
| 0xFC | 0x84 | 0b1'0000100 | f32.div_ceil            | /_ceil              |
| 0xFC | 0x85 | 0b1'0000101 | f64.sqrt_ceil           | sqrt_ceil           |
| 0xFC | 0x86 | 0b1'0000110 | f64.add_ceil            | +_ceil              |
| 0xFC | 0x87 | 0b1'0000111 | f64.sub_ceil            | -_ceil              |
| 0xFC | 0x88 | 0b1'0001000 | f64.mul_ceil            | *_ceil              |
| 0xFC | 0x89 | 0b1'0001001 | f64.div_ceil            | /_ceil              |
| 0xFC | 0x8a | 0b1'0001010 | f32.convert_i32_s_ceil  | convert_i32_s_ceil  |
| 0xFC | 0x8b | 0b1'0001011 | f32.convert_i32_u_ceil  | convert_i32_u_ceil  |
| 0xFC | 0x8c | 0b1'0001100 | f32.convert_i64_s_ceil  | convert_i64_s_ceil  |
| 0xFC | 0x8d | 0b1'0001101 | f32.convert_i64_u_ceil  | convert_i64_u_ceil  |
| 0xFC | 0x8e | 0b1'0001110 | f32.demote_f64_ceil     | demote_f64_ceil     |
| 0xFC | 0x8f | 0b1'0001111 | f64.convert_i32_s_ceil  | convert_i32_s_ceil  |
| 0xFC | 0x90 | 0b1'0010000 | f64.convert_i32_u_ceil  | convert_i32_u_ceil  |
| 0xFC | 0x91 | 0b1'0010001 | f64.convert_i64_s_ceil  | convert_i64_s_ceil  |
| 0xFC | 0x92 | 0b1'0010010 | f64.convert_i64_u_ceil  | convert_i64_u_ceil  |
| 0xFC | 0x93 | 0b1'0010011 | f64.promote_f32_ceil    | promote_f32_ceil    |
| 0xFC | 0x94 | 0b1'0010100 | f32.sqrt_floor          | sqrt_floor          |
| 0xFC | 0x95 | 0b1'0010101 | f32.add_floor           | +_floor             |
| 0xFC | 0x96 | 0b1'0010110 | f32.sub_floor           | -_floor             |
| 0xFC | 0x97 | 0b1'0010111 | f32.mul_floor           | *_floor             |
| 0xFC | 0x98 | 0b1'0011000 | f32.div_floor           | /_floor             |
| 0xFC | 0x99 | 0b1'0011001 | f64.sqrt_floor          | sqrt_floor          |
| 0xFC | 0x9a | 0b1'0011010 | f64.add_floor           | +_floor             |
| 0xFC | 0x9b | 0b1'0011011 | f64.sub_floor           | -_floor             |
| 0xFC | 0x9c | 0b1'0011100 | f64.mul_floor           | *_floor             |
| 0xFC | 0x9d | 0b1'0011101 | f64.div_floor           | /_floor             |
| 0xFC | 0x9e | 0b1'0011110 | f32.convert_i32_s_floor | convert_i32_s_floor |
| 0xFC | 0x9f | 0b1'0011111 | f32.convert_i32_u_floor | convert_i32_u_floor |
| 0xFC | 0xa0 | 0b1'0100000 | f32.convert_i64_s_floor | convert_i64_s_floor |
| 0xFC | 0xa1 | 0b1'0100001 | f32.convert_i64_u_floor | convert_i64_u_floor |
| 0xFC | 0xa2 | 0b1'0100010 | f32.demote_f64_floor    | demote_f64_floor    |
| 0xFC | 0xa3 | 0b1'0100011 | f64.convert_i32_s_floor | convert_i32_s_floor |
| 0xFC | 0xa4 | 0b1'0100100 | f64.convert_i32_u_floor | convert_i32_u_floor |
| 0xFC | 0xa5 | 0b1'0100101 | f64.convert_i64_s_floor | convert_i64_s_floor |
| 0xFC | 0xa6 | 0b1'0100110 | f64.convert_i64_u_floor | convert_i64_u_floor |
| 0xFC | 0xa7 | 0b1'0100111 | f64.promote_f32_floor   | promote_f32_floor   |
| 0xFC | 0xa8 | 0b1'0101000 | f32.sqrt_trunc          | sqrt_trunc          |
| 0xFC | 0xa9 | 0b1'0101001 | f32.add_trunc           | +_trunc             |
| 0xFC | 0xaa | 0b1'0101010 | f32.sub_trunc           | -_trunc             |
| 0xFC | 0xab | 0b1'0101011 | f32.mul_trunc           | *_trunc             |
| 0xFC | 0xac | 0b1'0101100 | f32.div_trunc           | /_trunc             |
| 0xFC | 0xad | 0b1'0101101 | f64.sqrt_trunc          | sqrt_trunc          |
| 0xFC | 0xae | 0b1'0101110 | f64.add_trunc           | +_trunc             |
| 0xFC | 0xaf | 0b1'0101111 | f64.sub_trunc           | -_trunc             |
| 0xFC | 0xb0 | 0b1'0110000 | f64.mul_trunc           | *_trunc             |
| 0xFC | 0xb1 | 0b1'0110001 | f64.div_trunc           | /_trunc             |
| 0xFC | 0xb2 | 0b1'0110010 | f32.convert_i32_s_trunc | convert_i32_s_trunc |
| 0xFC | 0xb3 | 0b1'0110011 | f32.convert_i32_u_trunc | convert_i32_u_trunc |
| 0xFC | 0xb4 | 0b1'0110100 | f32.convert_i64_s_trunc | convert_i64_s_trunc |
| 0xFC | 0xb5 | 0b1'0110101 | f32.convert_i64_u_trunc | convert_i64_u_trunc |
| 0xFC | 0xb6 | 0b1'0110110 | f32.demote_f64_trunc    | demote_f64_trunc    |
| 0xFC | 0xb7 | 0b1'0110111 | f64.convert_i32_s_trunc | convert_i32_s_trunc |
| 0xFC | 0xb8 | 0b1'0111000 | f64.convert_i32_u_trunc | convert_i32_u_trunc |
| 0xFC | 0xb9 | 0b1'0111001 | f64.convert_i64_s_trunc | convert_i64_s_trunc |
| 0xFC | 0xba | 0b1'0111010 | f64.convert_i64_u_trunc | convert_i64_u_trunc |
| 0xFC | 0xbb | 0b1'0111011 | f64.promote_f32_trunc   | promote_f32_trunc   |

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

For a viable implementation the performance or startup latence is supposed to be faster than what is doable in user land. For example this user land [implementation](https://gitlab.com/pauldennis/rounding-fiasco/-/blob/main/README.md) is 13.77 MiB in size and uses 658623 instructions since it has to emulate the [FPU](https://en.wikipedia.org/wiki/Floating-point_unit) of the cpu.
