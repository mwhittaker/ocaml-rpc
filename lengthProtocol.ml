open Core.Std
open Async.Std

let length_rpc =
  Rpc.Rpc.create
    ~name:"length"
    ~version:1
    ~bin_query:String.bin_t
    ~bin_response:Int.bin_t
