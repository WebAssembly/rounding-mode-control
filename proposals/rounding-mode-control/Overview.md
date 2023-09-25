# rounding variants of numeric operations

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
| | 0xB2 |    f32.convert_i32_s                      |
| | 0xB3 |    f32.convert_i32_u                      |
| | 0xB4 |    f32.convert_i64_s                      |
| | 0xB5 |    f32.convert_i64_u                      |
| | 0xB6 |    f32.demote                             |
| | 0xB9 |    f64.convert_i64_s                      |
| | 0xBA |    f64.convert_i64_u                      |

That is the conversion-to/between floating points and the opertors `+-*/√` within the floats. Not every conversion or operation is excact. One has to round. In the existing instructions the closest neighbour is choosen. In case neither neighbour is closer to the exact result the one with an even mantissa is choosen.

There are other options for rouding namely:

|name|description|
|-----|-------|
|ceil|take the neighbour that is greater|
|floor|take the neighbour that is less|
|trunc|take the number that is closer to zero|

This proposal proposes to extend the matrix of floating point instructions by combining them with a new dimension called a rounding variant. There are some branch preparation instructions that are used for most the important use case, that being interval arithmetic. This results in the following new instructions:


|prefix|opcode    |opcode binary         |name                     | pretty string        |
|------|-----------|-----------------------|---------------------------|-----------------------|
| 0xFC | 0x1C      | 0b00011100            | f32.sign_bit              | sign_bit              |
| 0xFC | 0x1D      | 0b00011101            | f64.sign_bit              | sign_bit              |
| 0xFC | 0x1E      | 0b00011110            | i32.arithmetic_signum_f32 | arithmetic_signum_f32 |
| 0xFC | 0x1F      | 0b00011111            | i32.arithmetic_signum_f64 | arithmetic_signum_f64 |
| 0xFC | 0x20 0x00 | 0b00100000 0b00000000 | f32.sqrt_ceil             | sqrt_ceil             |
| 0xFC | 0x20 0x01 | 0b00100000 0b00000001 | f32.sqrt_floor            | sqrt_floor            |
| 0xFC | 0x20 0x02 | 0b00100000 0b00000010 | f32.sqrt_trunc            | sqrt_trunc            |
| 0xFC | 0x21 0x00 | 0b00100001 0b00000000 | f32.add_ceil              | +_ceil                |
| 0xFC | 0x21 0x01 | 0b00100001 0b00000001 | f32.add_floor             | +_floor               |
| 0xFC | 0x21 0x02 | 0b00100001 0b00000010 | f32.add_trunc             | +_trunc               |
| 0xFC | 0x22 0x00 | 0b00100010 0b00000000 | f32.sub_ceil              | -_ceil                |
| 0xFC | 0x22 0x01 | 0b00100010 0b00000001 | f32.sub_floor             | -_floor               |
| 0xFC | 0x22 0x02 | 0b00100010 0b00000010 | f32.sub_trunc             | -_trunc               |
| 0xFC | 0x23 0x00 | 0b00100011 0b00000000 | f32.mul_ceil              | *_ceil                |
| 0xFC | 0x23 0x01 | 0b00100011 0b00000001 | f32.mul_floor             | *_floor               |
| 0xFC | 0x23 0x02 | 0b00100011 0b00000010 | f32.mul_trunc             | *_trunc               |
| 0xFC | 0x24 0x00 | 0b00100100 0b00000000 | f32.div_ceil              | /_ceil                |
| 0xFC | 0x24 0x01 | 0b00100100 0b00000001 | f32.div_floor             | /_floor               |
| 0xFC | 0x24 0x02 | 0b00100100 0b00000010 | f32.div_trunc             | /_trunc               |
| 0xFC | 0x25 0x00 | 0b00100101 0b00000000 | f64.sqrt_ceil             | sqrt_ceil             |
| 0xFC | 0x25 0x01 | 0b00100101 0b00000001 | f64.sqrt_floor            | sqrt_floor            |
| 0xFC | 0x25 0x02 | 0b00100101 0b00000010 | f64.sqrt_trunc            | sqrt_trunc            |
| 0xFC | 0x26 0x00 | 0b00100110 0b00000000 | f64.add_ceil              | +_ceil                |
| 0xFC | 0x26 0x01 | 0b00100110 0b00000001 | f64.add_floor             | +_floor               |
| 0xFC | 0x26 0x02 | 0b00100110 0b00000010 | f64.add_trunc             | +_trunc               |
| 0xFC | 0x27 0x00 | 0b00100111 0b00000000 | f64.sub_ceil              | -_ceil                |
| 0xFC | 0x27 0x01 | 0b00100111 0b00000001 | f64.sub_floor             | -_floor               |
| 0xFC | 0x27 0x02 | 0b00100111 0b00000010 | f64.sub_trunc             | -_trunc               |
| 0xFC | 0x28 0x00 | 0b00101000 0b00000000 | f64.mul_ceil              | *_ceil                |
| 0xFC | 0x28 0x01 | 0b00101000 0b00000001 | f64.mul_floor             | *_floor               |
| 0xFC | 0x28 0x02 | 0b00101000 0b00000010 | f64.mul_trunc             | *_trunc               |
| 0xFC | 0x29 0x00 | 0b00101001 0b00000000 | f64.div_ceil              | /_ceil                |
| 0xFC | 0x29 0x01 | 0b00101001 0b00000001 | f64.div_floor             | /_floor               |
| 0xFC | 0x29 0x02 | 0b00101001 0b00000010 | f64.div_trunc             | /_trunc               |
| 0xFC | 0x2A 0x00 | 0b00101010 0b00000000 | f32.convert_i32_s_ceil    | convert_i32_s_ceil    |
| 0xFC | 0x2A 0x01 | 0b00101010 0b00000001 | f32.convert_i32_s_floor   | convert_i32_s_floor   |
| 0xFC | 0x2A 0x02 | 0b00101010 0b00000010 | f32.convert_i32_s_trunc   | convert_i32_s_trunc   |
| 0xFC | 0x2B 0x00 | 0b00101011 0b00000000 | f32.convert_i32_u_ceil    | convert_i32_u_ceil    |
| 0xFC | 0x2B 0x01 | 0b00101011 0b00000001 | f32.convert_i32_u_floor   | convert_i32_u_floor   |
| 0xFC | 0x2B 0x02 | 0b00101011 0b00000010 | f32.convert_i32_u_trunc   | convert_i32_u_trunc   |
| 0xFC | 0x2C 0x00 | 0b00101100 0b00000000 | f32.convert_i64_s_ceil    | convert_i64_s_ceil    |
| 0xFC | 0x2C 0x01 | 0b00101100 0b00000001 | f32.convert_i64_s_floor   | convert_i64_s_floor   |
| 0xFC | 0x2C 0x02 | 0b00101100 0b00000010 | f32.convert_i64_s_trunc   | convert_i64_s_trunc   |
| 0xFC | 0x2D 0x00 | 0b00101101 0b00000000 | f32.convert_i64_u_ceil    | convert_i64_u_ceil    |
| 0xFC | 0x2D 0x01 | 0b00101101 0b00000001 | f32.convert_i64_u_floor   | convert_i64_u_floor   |
| 0xFC | 0x2D 0x02 | 0b00101101 0b00000010 | f32.convert_i64_u_trunc   | convert_i64_u_trunc   |
| 0xFC | 0x2E 0x00 | 0b00101110 0b00000000 | f32.demote_f64_ceil       | demote_f64_ceil       |
| 0xFC | 0x2E 0x01 | 0b00101110 0b00000001 | f32.demote_f64_floor      | demote_f64_floor      |
| 0xFC | 0x2E 0x02 | 0b00101110 0b00000010 | f32.demote_f64_trunc      | demote_f64_trunc      |
| 0xFC | 0x2F 0x00 | 0b00101111 0b00000000 | f64.convert_i64_s_ceil    | convert_i64_s_ceil    |
| 0xFC | 0x2F 0x01 | 0b00101111 0b00000001 | f64.convert_i64_s_floor   | convert_i64_s_floor   |
| 0xFC | 0x2F 0x02 | 0b00101111 0b00000010 | f64.convert_i64_s_trunc   | convert_i64_s_trunc   |
| 0xFC | 0x30 0x00 | 0b00110000 0b00000000 | f64.convert_i64_u_ceil    | convert_i64_u_ceil    |
| 0xFC | 0x30 0x01 | 0b00110000 0b00000001 | f64.convert_i64_u_floor   | convert_i64_u_floor   |
| 0xFC | 0x30 0x02 | 0b00110000 0b00000010 | f64.convert_i64_u_trunc   | convert_i64_u_trunc   |

## semantics

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
| O.f_I_ceil(x)  | `=` | `min { y \| y ∈ O, F(x) <= y }`                       |
| O.f_I_floor(x) | `=` | `max { y \| y ∈ O, y <= F(x) }`                       |
| O.f_I_trunc(x) | `=` | `if 0 < F(x) then O.f_I_floor(x) else O.f_I_ceil(x)` |

This definition is not complete as the result might be zero and in that case the sign has to be determined. In that case IEEE defines the result as `+0.0` with following exception: Should `f` be `+` or `-` and the result be zero then the sign is `-`. In Formal notation this gives us: (higher listed rules have precedence)


| | | |
| :------------- | :---: | :----------------------------------------------------------- |
| O.±_I_floor(x) |  `=`  |  `min (maximal { y \| y ∈ O, y <= F(x) })`                    |
| O.f_I_ceil(x)  |  `=`  |  `max { y \| y ∈ O\{-0.0},      F(x) <= y }`                  |
| O.f_I_floor(x) |  `=`  |  `min { y \| y ∈ O\{-0.0}, y <= F(x)      })`                 |
| O.f_I_trunc(x) |  `=`  |  `if 0 < F(x) then O.f_I_floor(x) else O.f_I_ceil(x)`        |

Here means `minimal` a functions that gives the set of minimal elements of the input set. So the result set is either a non zero number singleton or the set `{-0.0, 0.0}`. Here `max` and `min` are parameterized on the relation `<` with the additional having `-0.0 < 0.0` to make the relation total.

## redundants

The following functions are redundant and simple to implement:
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
It turns out that the functions above are respectively equivalent to `f64.convert_i32_s` and `f64.convert_i32_u`. The reason is that an `f64` float contains a 53-bit mantissa, which is sufficient to accommodate an entire 'i32'.




```
f64.promote_f32_ceil
f64.promote_f32_floor
f64.promote_f32_trunc
```
These are all equivalent to `f64.promote_f32` because such promotion would be lossless and therefore agnostic to rounding mode.



Technically the redundant functions do not add much normative value. But they are practical benefits of having them:

The operation and conversion tensor does not get arbitrary holes. This makes it easier to reason about the operations. The mathematical defenition of the semantic of `f64.promote_f32_ceil` is still different from `f64.promote_f32`. It is easier to express intend that way.

Having the full conversion tensor may improve portability of WebAssembly: With rounded instructions it is possible to write algorithms that are independent of and equivalent over different number formats. For example a user of the `wasm2c` tool could purposefully relax the requirement of `f32` to be IEEE floating point. The `c` standard does not require `flaot` to be IEEE. Lets say `f32` gets implemented by the plattform as `posit32`. `posit32` is a number format with more precicion around `1.0` than IEEE. That way there might be numbers in `float` that are not representable in `double`. Now you need `promot` with a rounding variation so that your iterating enclosing loop is still converging.

## performance

A user might expect performance improvement when avoiding 2 or 3 of the 4 rounding variants all together on certain hardware.
