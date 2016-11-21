open Core.Std
open Async.Std
open KeyValueStoreProtocol

let get conn key =
  Rpc.Rpc.dispatch_exn KeyValueStoreProtocol.get_rpc conn key

let set conn key data =
  Rpc.Rpc.dispatch_exn KeyValueStoreProtocol.set_rpc conn {key; data}

let main () : unit Deferred.t =
  let host = "localhost" in
  let port = 8888 in
  Tcp.with_connection (Tcp.to_host_and_port host port) (fun _ r w ->
    Rpc.Connection.create r w ~connection_state:(fun _ -> ()) >>= function
    | Error exn -> raise exn
    | Ok conn ->
      set conn "one" "uno" >>= fun () ->
      set conn "two" "dos" >>= fun () ->
      set conn "three" "tres" >>= fun () ->
      get conn "one" >>= fun one ->
      get conn "two" >>= fun two ->
      get conn "three" >>= fun three ->
      get conn "four" >>= fun four ->
      printf "one = %s\n" (Option.value one ~default:"None");
      printf "two = %s\n" (Option.value two ~default:"None");
      printf "three = %s\n" (Option.value three ~default:"None");
      printf "four = %s\n" (Option.value four ~default:"None");
      return ()
  )

let () =
  Command.(run (async ~summary:"Length client." Spec.empty main))
