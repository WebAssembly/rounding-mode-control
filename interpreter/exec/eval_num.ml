open Types
open Values


(* Int operators *)

module IntOp (IXX : Ixx.S) (Num : NumType with type t = IXX.t) =
struct
  open Ast.IntOp
  open Num

  let unop op =
    let f = match op with
      | Clz -> IXX.clz
      | Ctz -> IXX.ctz
      | Popcnt -> IXX.popcnt
      | ExtendS sz -> IXX.extend_s (8 * packed_size sz)
    in fun v -> to_num (f (of_num 1 v))

  let binop op =
    let f = match op with
      | Add -> IXX.add
      | Sub -> IXX.sub
      | Mul -> IXX.mul
      | DivS -> IXX.div_s
      | DivU -> IXX.div_u
      | RemS -> IXX.rem_s
      | RemU -> IXX.rem_u
      | And -> IXX.and_
      | Or -> IXX.or_
      | Xor -> IXX.xor
      | Shl -> IXX.shl
      | ShrU -> IXX.shr_u
      | ShrS -> IXX.shr_s
      | Rotl -> IXX.rotl
      | Rotr -> IXX.rotr
    in fun v1 v2 -> to_num (f (of_num 1 v1) (of_num 2 v2))

  let testop op =
    let f = match op with
      | Eqz -> IXX.eqz
    in fun v -> f (of_num 1 v)

  let relop op =
    let f = match op with
      | Eq -> IXX.eq
      | Ne -> IXX.ne
      | LtS -> IXX.lt_s
      | LtU -> IXX.lt_u
      | LeS -> IXX.le_s
      | LeU -> IXX.le_u
      | GtS -> IXX.gt_s
      | GtU -> IXX.gt_u
      | GeS -> IXX.ge_s
      | GeU -> IXX.ge_u
    in fun v1 v2 -> f (of_num 1 v1) (of_num 2 v2)
end

module I32Op = IntOp (I32) (I32Num)
module I64Op = IntOp (I64) (I64Num)


(* Float operators *)

module FloatOp (FXX : Fxx.S) (Num : NumType with type t = FXX.t) =
struct
  open Ast.FloatOp
  open Num

  let unop op =
    let f = match op with
      | Neg -> FXX.neg
      | Abs -> FXX.abs
      | Sqrt  -> FXX.sqrt
      | SqrtCeil -> (fun v1 ->
          ItvUtils.Float.set_round_up ();
          let result = FXX.sqrt v1 in
          ItvUtils.Float.set_round_near ();
          result)
      | SqrtFloor -> (fun v1 ->
          ItvUtils.Float.set_round_down ();
          let result = FXX.sqrt v1 in
          ItvUtils.Float.set_round_near ();
          result)
      | SqrtTrunc -> (fun v1 ->
          ItvUtils.Float.set_round_zero ();
          let result = FXX.sqrt v1 in
          ItvUtils.Float.set_round_near ();
          result)
      | Ceil -> FXX.ceil
      | Floor -> FXX.floor
      | Trunc -> FXX.trunc
      | Nearest -> FXX.nearest
    in fun v -> to_num (f (of_num 1 v))

  let binop op =
    let f = match op with
      | Add -> FXX.add
      | AddCeil -> (fun v1 v2 ->
          ItvUtils.Float.set_round_up ();
          let result = FXX.add v1 v2 in
          ItvUtils.Float.set_round_near ();
          result)
      | AddFloor -> (fun v1 v2 ->
          ItvUtils.Float.set_round_down ();
          let result = FXX.add v1 v2 in
          ItvUtils.Float.set_round_near ();
          result)
      | AddTrunc -> (fun v1 v2 ->
          ItvUtils.Float.set_round_zero ();
          let result = FXX.add v1 v2 in
          ItvUtils.Float.set_round_near ();
          result)
      | SubCeil -> (fun v1 v2 ->
          ItvUtils.Float.set_round_up ();
          let result = FXX.sub v1 v2 in
          ItvUtils.Float.set_round_near ();
          result)
      | SubFloor -> (fun v1 v2 ->
          ItvUtils.Float.set_round_down ();
          let result = FXX.sub v1 v2 in
          ItvUtils.Float.set_round_near ();
          result)
      | SubTrunc -> (fun v1 v2 ->
          ItvUtils.Float.set_round_zero ();
          let result = FXX.sub v1 v2 in
          ItvUtils.Float.set_round_near ();
          result)
      | MulCeil -> (fun v1 v2 ->
          ItvUtils.Float.set_round_up ();
          let result = FXX.mul v1 v2 in
          ItvUtils.Float.set_round_near ();
          result)
      | MulFloor -> (fun v1 v2 ->
          ItvUtils.Float.set_round_down ();
          let result = FXX.mul v1 v2 in
          ItvUtils.Float.set_round_near ();
          result)
      | MulTrunc -> (fun v1 v2 ->
          ItvUtils.Float.set_round_zero ();
          let result = FXX.mul v1 v2 in
          ItvUtils.Float.set_round_near ();
          result)
      | DivCeil -> (fun v1 v2 ->
          ItvUtils.Float.set_round_up ();
          let result = FXX.div v1 v2 in
          ItvUtils.Float.set_round_near ();
          result)
      | DivFloor -> (fun v1 v2 ->
          ItvUtils.Float.set_round_down ();
          let result = FXX.div v1 v2 in
          ItvUtils.Float.set_round_near ();
          result)
      | DivTrunc -> (fun v1 v2 ->
          ItvUtils.Float.set_round_zero ();
          let result = FXX.div v1 v2 in
          ItvUtils.Float.set_round_near ();
          result)

      | Sub -> FXX.sub
      | Mul -> FXX.mul
      | Div -> FXX.div
      | Min -> FXX.min
      | Max -> FXX.max
      | CopySign -> FXX.copysign
    in fun v1 v2 -> to_num (f (of_num 1 v1) (of_num 2 v2))

  let testop op = assert false

  let relop op =
    let f = match op with
      | Eq -> FXX.eq
      | Ne -> FXX.ne
      | Lt -> FXX.lt
      | Le -> FXX.le
      | Gt -> FXX.gt
      | Ge -> FXX.ge
    in fun v1 v2 -> f (of_num 1 v1) (of_num 2 v2)
end

module F32Op = FloatOp (F32) (F32Num)
module F64Op = FloatOp (F64) (F64Num)


(* Conversion operators *)

module I32CvtOp =
struct
  open Ast.IntOp

  let cvtop op v =
    let i = match op with
      | WrapI64 -> I32_convert.wrap_i64 (I64Num.of_num 1 v)
      | TruncUF32 -> I32_convert.trunc_f32_u (F32Num.of_num 1 v)
      | TruncSF32 -> I32_convert.trunc_f32_s (F32Num.of_num 1 v)
      | TruncUF64 -> I32_convert.trunc_f64_u (F64Num.of_num 1 v)
      | TruncSF64 -> I32_convert.trunc_f64_s (F64Num.of_num 1 v)
      | TruncSatUF32 -> I32_convert.trunc_sat_f32_u (F32Num.of_num 1 v)
      | TruncSatSF32 -> I32_convert.trunc_sat_f32_s (F32Num.of_num 1 v)
      | TruncSatUF64 -> I32_convert.trunc_sat_f64_u (F64Num.of_num 1 v)
      | TruncSatSF64 -> I32_convert.trunc_sat_f64_s (F64Num.of_num 1 v)
      | ReinterpretFloat -> I32_convert.reinterpret_f32 (F32Num.of_num 1 v)
      | ExtendUI32 -> raise (TypeError (1, v, I32Type))
      | ExtendSI32 -> raise (TypeError (1, v, I32Type))
    in I32Num.to_num i
end

module I64CvtOp =
struct
  open Ast.IntOp

  let cvtop op v =
    let i = match op with
      | ExtendUI32 -> I64_convert.extend_i32_u (I32Num.of_num 1 v)
      | ExtendSI32 -> I64_convert.extend_i32_s (I32Num.of_num 1 v)
      | TruncUF32 -> I64_convert.trunc_f32_u (F32Num.of_num 1 v)
      | TruncSF32 -> I64_convert.trunc_f32_s (F32Num.of_num 1 v)
      | TruncUF64 -> I64_convert.trunc_f64_u (F64Num.of_num 1 v)
      | TruncSF64 -> I64_convert.trunc_f64_s (F64Num.of_num 1 v)
      | TruncSatUF32 -> I64_convert.trunc_sat_f32_u (F32Num.of_num 1 v)
      | TruncSatSF32 -> I64_convert.trunc_sat_f32_s (F32Num.of_num 1 v)
      | TruncSatUF64 -> I64_convert.trunc_sat_f64_u (F64Num.of_num 1 v)
      | TruncSatSF64 -> I64_convert.trunc_sat_f64_s (F64Num.of_num 1 v)
      | ReinterpretFloat -> I64_convert.reinterpret_f64 (F64Num.of_num 1 v)
      | WrapI64 -> raise (TypeError (1, v, I64Type))
    in I64Num.to_num i
end

module F32CvtOp =
struct
  open Ast.FloatOp

  let cvtop op v =
    let z = match op with
      | DemoteF64 -> F32_convert.demote_f64 (F64Num.of_num 1 v)
      | DemoteCeilF64 ->
        ItvUtils.Float.set_round_up ();
        let result = F32_convert.demote_f64 (F64Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | DemoteFloorF64 ->
        ItvUtils.Float.set_round_down ();
        let result = F32_convert.demote_f64 (F64Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | DemoteTruncF64 ->
        ItvUtils.Float.set_round_zero ();
        let result = F32_convert.demote_f64 (F64Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | ConvertSI32 -> F32_convert.convert_i32_s (I32Num.of_num 1 v)
      | ConvertCeilSI32 ->
        ItvUtils.Float.set_round_up ();
        let result = F32_convert.convert_i32_s (I32Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | ConvertFloorSI32 ->
        ItvUtils.Float.set_round_down ();
        let result = F32_convert.convert_i32_s (I32Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | ConvertTruncSI32 ->
        ItvUtils.Float.set_round_zero ();
        let result = F32_convert.convert_i32_s (I32Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | ConvertUI32 -> F32_convert.convert_i32_u (I32Num.of_num 1 v)
      | ConvertCeilUI32 ->
        ItvUtils.Float.set_round_up ();
        let result = F32_convert.convert_i32_u (I32Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | ConvertFloorUI32 ->
        ItvUtils.Float.set_round_down ();
        let result = F32_convert.convert_i32_u (I32Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | ConvertTruncUI32 ->
        ItvUtils.Float.set_round_zero ();
        let result = F32_convert.convert_i32_u (I32Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | ConvertSI64 -> F32_convert.convert_i64_s (I64Num.of_num 1 v)
      | ConvertCeilSI64 ->
        ItvUtils.Float.set_round_up ();
        let result = F32_convert.convert_i64_s (I64Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | ConvertFloorSI64 ->
        ItvUtils.Float.set_round_down ();
        let result = F32_convert.convert_i64_s (I64Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | ConvertTruncSI64 ->
        ItvUtils.Float.set_round_zero ();
        let result = F32_convert.convert_i64_s (I64Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | ConvertUI64 -> F32_convert.convert_i64_u (I64Num.of_num 1 v)
      | ConvertCeilUI64 ->
        ItvUtils.Float.set_round_up ();
        let result = F32_convert.convert_i64_u (I64Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | ConvertFloorUI64 ->
        ItvUtils.Float.set_round_down ();
        let result = F32_convert.convert_i64_u (I64Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | ConvertTruncUI64 ->
        ItvUtils.Float.set_round_zero ();
        let result = F32_convert.convert_i64_u (I64Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | ReinterpretInt -> F32_convert.reinterpret_i32 (I32Num.of_num 1 v)
      | PromoteF32 -> raise (TypeError (1, v, F32Type))
      | PromoteCeilF32 -> raise (TypeError (1, v, F32Type))
      | PromoteFloorF32 -> raise (TypeError (1, v, F32Type))
      | PromoteTruncF32 -> raise (TypeError (1, v, F32Type))
    in F32Num.to_num z
end

module F64CvtOp =
struct
  open Ast.FloatOp

  let cvtop op v =
    let z = match op with
      | PromoteF32 -> F64_convert.promote_f32 (F32Num.of_num 1 v)
      | PromoteCeilF32 ->
        ItvUtils.Float.set_round_up ();
        let result = F64_convert.promote_f32 (F32Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | PromoteFloorF32 ->
        ItvUtils.Float.set_round_down ();
        let result = F64_convert.promote_f32 (F32Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | PromoteTruncF32 ->
        ItvUtils.Float.set_round_zero ();
        let result = F64_convert.promote_f32 (F32Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | ConvertSI32 -> F64_convert.convert_i32_s (I32Num.of_num 1 v)
      | ConvertCeilSI32 ->
        ItvUtils.Float.set_round_up ();
        let result = F64_convert.convert_i32_s (I32Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | ConvertFloorSI32 ->
        ItvUtils.Float.set_round_down ();
        let result = F64_convert.convert_i32_s (I32Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | ConvertTruncSI32 ->
        ItvUtils.Float.set_round_zero ();
        let result = F64_convert.convert_i32_s (I32Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | ConvertUI32 -> F64_convert.convert_i32_u (I32Num.of_num 1 v)
      | ConvertCeilUI32 ->
        ItvUtils.Float.set_round_up ();
        let result = F64_convert.convert_i32_u (I32Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | ConvertFloorUI32 ->
        ItvUtils.Float.set_round_down ();
        let result = F64_convert.convert_i32_u (I32Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | ConvertTruncUI32 ->
        ItvUtils.Float.set_round_zero ();
        let result = F64_convert.convert_i32_u (I32Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | ConvertSI64 -> F64_convert.convert_i64_s (I64Num.of_num 1 v)
      | ConvertCeilSI64 ->
        ItvUtils.Float.set_round_up ();
        let result = F64_convert.convert_i64_s (I64Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | ConvertFloorSI64 ->
        ItvUtils.Float.set_round_down ();
        let result = F64_convert.convert_i64_s (I64Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | ConvertTruncSI64 ->
        ItvUtils.Float.set_round_zero ();
        let result = F64_convert.convert_i64_s (I64Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | ConvertUI64 -> F64_convert.convert_i64_u (I64Num.of_num 1 v)
      | ConvertCeilUI64 ->
        ItvUtils.Float.set_round_up ();
        let result = F64_convert.convert_i64_u (I64Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | ConvertFloorUI64 ->
        ItvUtils.Float.set_round_down ();
        let result = F64_convert.convert_i64_u (I64Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | ConvertTruncUI64 ->
        ItvUtils.Float.set_round_zero ();
        let result = F64_convert.convert_i64_u (I64Num.of_num 1 v) in
        ItvUtils.Float.set_round_near ();
        result
      | ReinterpretInt -> F64_convert.reinterpret_i64 (I64Num.of_num 1 v)
      | DemoteF64 -> raise (TypeError (1, v, F64Type))
      | DemoteCeilF64 -> raise (TypeError (1, v, F64Type))
      | DemoteFloorF64 -> raise (TypeError (1, v, F64Type))
      | DemoteTruncF64 -> raise (TypeError (1, v, F64Type))
    in F64Num.to_num z
end

(* Dispatch *)

let op i32 i64 f32 f64 = function
  | I32 x -> i32 x
  | I64 x -> i64 x
  | F32 x -> f32 x
  | F64 x -> f64 x

let eval_unop = op I32Op.unop I64Op.unop F32Op.unop F64Op.unop
let eval_binop = op I32Op.binop I64Op.binop F32Op.binop F64Op.binop
let eval_testop = op I32Op.testop I64Op.testop F32Op.testop F64Op.testop
let eval_relop = op I32Op.relop I64Op.relop F32Op.relop F64Op.relop
let eval_cvtop = op I32CvtOp.cvtop I64CvtOp.cvtop F32CvtOp.cvtop F64CvtOp.cvtop
