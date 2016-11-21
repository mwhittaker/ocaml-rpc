open Core.Std
open Async.Std

let length () (s: string) : int Deferred.t =
  return (String.length s)

let main () : unit Deferred.t =
  let port = 8888 in
  let implementations = Rpc.Implementations.create_exn
    ~on_unknown_rpc:`Raise
    ~implementations:[Rpc.Rpc.implement LengthProtocol.length_rpc length]
  in
  printf "Server listening on port %d.\n" port;
  Tcp.Server.create (Tcp.on_port port) (fun _ r w ->
    Rpc.Connection.server_with_close
      r w
      ~on_handshake_error:`Raise
      ~connection_state:(fun _ -> ())
      ~implementations
  ) >>= Tcp.Server.close_finished

let () =
  Command.(run (async ~summary:"Length server." Spec.empty main))
