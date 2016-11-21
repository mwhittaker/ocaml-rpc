open Core.Std
open Async.Std
open KeyValueStoreProtocol

type store = string String.Table.t

let get (s: store) (key: key) : data option Deferred.t =
  return (String.Table.find s key)

let set (s: store) ({key; data}: key_data) : unit Deferred.t =
  ignore (String.Table.add s ~key ~data);
  return ()

let main () : unit Deferred.t =
  let port = 8888 in
  let implementations = Rpc.Implementations.create_exn
    ~on_unknown_rpc:`Raise
    ~implementations:[
      Rpc.Rpc.implement KeyValueStoreProtocol.get_rpc get;
      Rpc.Rpc.implement KeyValueStoreProtocol.set_rpc set;
    ]
  in
  printf "Server listening on port %d.\n" port;
  let store = String.Table.create () in
  Tcp.Server.create (Tcp.on_port port) (fun _ r w ->
    Rpc.Connection.server_with_close
      r w
      ~on_handshake_error:`Raise
      ~connection_state:(fun _ -> store)
      ~implementations
  ) >>= Tcp.Server.close_finished

let () =
  Command.(run (async ~summary:"Key-value store server." Spec.empty main))
