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
| | 0xB7 |    f64.convert_i32_s                      |
| | 0xB8 |    f64.convert_i32_u                      |
| | 0xB9 |    f64.convert_i64_s                      |
| | 0xBA |    f64.convert_i64_u                      |
| | 0xBB |    f64.promote_f32                        |

That is the conversion-to/between floating points and the opertors `+-*/√` within the floats. Not every conversion or operation is excact. One has to round. In the existing instructions the closest neighbour is choosen. In case neither neighbour is closer to the exact result the one with an even mantissa is choosen.

There are other options for rouding namely:

|name|description|
|-----|-------|
|ceil|take the neighbour that is greater|
|floor|take the neighbour that is less|
|trunc|take the number that is closer to zero|

This proposal proposes to extend matrix of floating point instruction comnination with a new dimension called a rounding variant. There are some branching prepare instructions that are used for most important usecase that is interval arithmetic as well. This results in the following new instructions:


|prefix|opcode |opcode binary  |name                       | pretty string         |
|------|-------|---------------|---------------------------|-----------------------|
| 0xfc | 0x1C  |               | f32.sign_bit              | sign_bit              |
| 0xfc | 0x1D  |               | f64.sign_bit              | sign_bit              |
| 0xfc | 0x1E  |               | i32.arithmetic_signum_f32 | arithmetic_signum_f32 |
| 0xfc | 0x1F  |               | i32.arithmetic_signum_f64 | arithmetic_signum_f64 |
| 0xfc | 0x100 | 0b1'00'000000 | f32.sqrt_ceil             | sqrt_ceil             |
| 0xfc | 0x140 | 0b1'01'000000 | f32.sqrt_floor            | sqrt_floor            |
| 0xfc | 0x180 | 0b1'10'000000 | f32.sqrt_trunc            | sqrt_trunc            |
| 0xfc | 0x101 | 0b1'00'000001 | f32.add_ceil              | +_ceil                |
| 0xfc | 0x141 | 0b1'01'000001 | f32.add_floor             | +_floor               |
| 0xfc | 0x181 | 0b1'10'000001 | f32.add_trunc             | +_trunc               |
| 0xfc | 0x102 | 0b1'00'000010 | f32.sub_ceil              | -_ceil                |
| 0xfc | 0x142 | 0b1'01'000010 | f32.sub_floor             | -_floor               |
| 0xfc | 0x182 | 0b1'10'000010 | f32.sub_trunc             | -_trunc               |
| 0xfc | 0x103 | 0b1'00'000011 | f32.mul_ceil              | *_ceil                |
| 0xfc | 0x143 | 0b1'01'000011 | f32.mul_floor             | *_floor               |
| 0xfc | 0x183 | 0b1'10'000011 | f32.mul_trunc             | *_trunc               |
| 0xfc | 0x104 | 0b1'00'000100 | f32.div_ceil              | /_ceil                |
| 0xfc | 0x144 | 0b1'01'000100 | f32.div_floor             | /_floor               |
| 0xfc | 0x184 | 0b1'10'000100 | f32.div_trunc             | /_trunc               |
| 0xfc | 0x105 | 0b1'00'000101 | f64.sqrt_ceil             | sqrt_ceil             |
| 0xfc | 0x145 | 0b1'01'000101 | f64.sqrt_floor            | sqrt_floor            |
| 0xfc | 0x185 | 0b1'10'000101 | f64.sqrt_trunc            | sqrt_trunc            |
| 0xfc | 0x106 | 0b1'00'000110 | f64.add_ceil              | +_ceil                |
| 0xfc | 0x146 | 0b1'01'000110 | f64.add_floor             | +_floor               |
| 0xfc | 0x186 | 0b1'10'000110 | f64.add_trunc             | +_trunc               |
| 0xfc | 0x107 | 0b1'00'000111 | f64.sub_ceil              | -_ceil                |
| 0xfc | 0x147 | 0b1'01'000111 | f64.sub_floor             | -_floor               |
| 0xfc | 0x187 | 0b1'10'000111 | f64.sub_trunc             | -_trunc               |
| 0xfc | 0x108 | 0b1'00'001000 | f64.mul_ceil              | *_ceil                |
| 0xfc | 0x148 | 0b1'01'001000 | f64.mul_floor             | *_floor               |
| 0xfc | 0x188 | 0b1'10'001000 | f64.mul_trunc             | *_trunc               |
| 0xfc | 0x109 | 0b1'00'001001 | f64.div_ceil              | /_ceil                |
| 0xfc | 0x149 | 0b1'01'001001 | f64.div_floor             | /_floor               |
| 0xfc | 0x189 | 0b1'10'001001 | f64.div_trunc             | /_trunc               |
| 0xfc | 0x10a | 0b1'00'001010 | f32.convert_i32_s_ceil    | convert_i32_s_ceil    |
| 0xfc | 0x14a | 0b1'01'001010 | f32.convert_i32_s_floor   | convert_i32_s_floor   |
| 0xfc | 0x18a | 0b1'10'001010 | f32.convert_i32_s_trunc   | convert_i32_s_trunc   |
| 0xfc | 0x10b | 0b1'00'001011 | f32.convert_i32_u_ceil    | convert_i32_u_ceil    |
| 0xfc | 0x14b | 0b1'01'001011 | f32.convert_i32_u_floor   | convert_i32_u_floor   |
| 0xfc | 0x18b | 0b1'10'001011 | f32.convert_i32_u_trunc   | convert_i32_u_trunc   |
| 0xfc | 0x10c | 0b1'00'001100 | f32.convert_i64_s_ceil    | convert_i64_s_ceil    |
| 0xfc | 0x14c | 0b1'01'001100 | f32.convert_i64_s_floor   | convert_i64_s_floor   |
| 0xfc | 0x18c | 0b1'10'001100 | f32.convert_i64_s_trunc   | convert_i64_s_trunc   |
| 0xfc | 0x10d | 0b1'00'001101 | f32.convert_i64_u_ceil    | convert_i64_u_ceil    |
| 0xfc | 0x14d | 0b1'01'001101 | f32.convert_i64_u_floor   | convert_i64_u_floor   |
| 0xfc | 0x18d | 0b1'10'001101 | f32.convert_i64_u_trunc   | convert_i64_u_trunc   |
| 0xfc | 0x10e | 0b1'00'001110 | f32.demote_f64_ceil       | demote_f64_ceil       |
| 0xfc | 0x14e | 0b1'01'001110 | f32.demote_f64_floor      | demote_f64_floor      |
| 0xfc | 0x18e | 0b1'10'001110 | f32.demote_f64_trunc      | demote_f64_trunc      |
| 0xfc | 0x10f | 0b1'00'001111 | f64.convert_i32_s_ceil    | convert_i32_s_ceil    |
| 0xfc | 0x14f | 0b1'01'001111 | f64.convert_i32_s_floor   | convert_i32_s_floor   |
| 0xfc | 0x18f | 0b1'10'001111 | f64.convert_i32_s_trunc   | convert_i32_s_trunc   |
| 0xfc | 0x110 | 0b1'00'010000 | f64.convert_i32_u_ceil    | convert_i32_u_ceil    |
| 0xfc | 0x150 | 0b1'01'010000 | f64.convert_i32_u_floor   | convert_i32_u_floor   |
| 0xfc | 0x190 | 0b1'10'010000 | f64.convert_i32_u_trunc   | convert_i32_u_trunc   |
| 0xfc | 0x111 | 0b1'00'010001 | f64.convert_i64_s_ceil    | convert_i64_s_ceil    |
| 0xfc | 0x151 | 0b1'01'010001 | f64.convert_i64_s_floor   | convert_i64_s_floor   |
| 0xfc | 0x191 | 0b1'10'010001 | f64.convert_i64_s_trunc   | convert_i64_s_trunc   |
| 0xfc | 0x112 | 0b1'00'010010 | f64.convert_i64_u_ceil    | convert_i64_u_ceil    |
| 0xfc | 0x152 | 0b1'01'010010 | f64.convert_i64_u_floor   | convert_i64_u_floor   |
| 0xfc | 0x192 | 0b1'10'010010 | f64.convert_i64_u_trunc   | convert_i64_u_trunc   |
| 0xfc | 0x113 | 0b1'00'010011 | f64.promote_f32_ceil      | promote_f32_ceil      |
| 0xfc | 0x153 | 0b1'01'010011 | f64.promote_f32_floor     | promote_f32_floor     |
| 0xfc | 0x193 | 0b1'10'010011 | f64.promote_f32_trunc     | promote_f32_trunc     |

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

The are redundants and simple to implement functions:
```
f32.convert_i32_s_ceil
f32.convert_i32_s_floor
f32.convert_i32_s_trunc
f32.convert_i32_u_ceil
f32.convert_i32_u_floor
f32.convert_i32_u_trunc
```
these functions could be implemented by using `extend` on the input `i32` to yield a `i64`. Then call `f32.convert_i64_x_round`.



```
f32.convert_i64_s_ceil
f32.convert_i64_s_floor
f32.convert_i64_s_trunc
f32.convert_i64_u_ceil
f32.convert_i64_u_floor
f32.convert_i64_u_trunc
```
these functions `f32.f_i64_x_round` could be implemented by utilizing `f64.f_i64_x_round` and then use `f32.demote_f64_round` on the intermediate result.



```
f64.convert_i32_s_ceil
f64.convert_i32_s_floor
f64.convert_i32_s_trunc
f64.convert_i32_u_ceil
f64.convert_i32_u_floor
f64.convert_i32_u_trunc
```
the functions are the same as `f64.convert_i32_s` and `f64.convert_i32_u` by chance. The reason is that a mantissa of 53 bits of the `f64` floats fits a whole `i32` in them.




```
f64.promote_f32_ceil
f64.promote_f32_floor
f64.promote_f32_trunc
```
these are the same as `f64.promote_f32` by chance.



Technically the redundant functions do not add much normative value. But they are practical benefits of having them:

The operation and conversion tensor does not get arbitrary holes. This makes it easier to reason about the operations. The mathematical defenition of the semantic of `f64.promote_f32_ceil` is still different from `f64.promote_f32`. It is easier to express intend that way.

Having the full conversion tensor may improve portability of WebAssembly: With rounded instructions it is possible to write algorithms that are independent of and equivalent over different number formats. For example a user of the `wasm2c` tool could purposefully relax the requirement of `f32` to be IEEE floating point. The `c` standard does not require `flaot` to be IEEE. Lets say `f32` gets implemented by the plattform as `posit32`. `posit32` is a number format with more precicion around `1.0` than IEEE. That way there might be numbers in `float` that are not representable in `double`. Now you need `promot` with a rounding variation so that your iterating enclosing loop is still converging.

## performance

A user might expect performance improvement when avoiding 2 or 3 of the 4 rounding variants all together on certain hardware.
