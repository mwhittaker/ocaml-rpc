open Core.Std
open Async.Std

type key = string [@@deriving bin_io, compare, sexp]
type data = string [@@deriving bin_io, compare, sexp]
type key_data = {key: key; data: data} [@@deriving bin_io, compare, sexp]

val get_rpc: (key, data option) Rpc.Rpc.t
val set_rpc: (key_data, unit) Rpc.Rpc.t
