open Core.Std
open Async.Std

let main () : unit Deferred.t =
  let host = "localhost" in
  let port = 8888 in
  Tcp.with_connection (Tcp.to_host_and_port host port) (fun _ r w ->
    Rpc.Connection.create r w ~connection_state:(fun _ -> ()) >>= function
    | Error exn -> raise exn
    | Ok conn ->
      let s = "foobar" in
      Rpc.Rpc.dispatch_exn LengthProtocol.length_rpc conn s >>| fun length ->
      printf "length(%s) = %d\n" s length
  )

let () =
  Command.(run (async ~summary:"Length client." Spec.empty main))
