open Core.Std
open Async.Std

type key = string [@@deriving bin_io, compare, sexp]
type data = string [@@deriving bin_io, compare, sexp]
type key_data = {key: key; data: data} [@@deriving bin_io, compare, sexp]

let get_rpc =
  Rpc.Rpc.create
    ~name:"get"
    ~version:1
    ~bin_query:String.bin_t
    ~bin_response:(Option.bin_t String.bin_t)

let set_rpc =
  Rpc.Rpc.create
    ~name:"set"
    ~version:1
    ~bin_query:bin_key_data
    ~bin_response:Unit.bin_t
