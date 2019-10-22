defmodule Tapestry do

  def start(_type, _args) do    # Builds the Tapestry topology
    # :observer.start()
    #args = System.argv()

    args = ["10", "10"]

    case args do
      [num_nodes, _num_requests] ->
        num_nodes = String.to_integer(num_nodes)
        #num_requests = String.to_integer(num_requests)
        Tapestry.DynamicSupervisor.start_link(args)     # TODO change this
        nodes = Tapestry.DynamicSupervisor.start_children(num_nodes, [])
        # nodes
        # Enum.map(nodes, fn x -> init_node(x))         # topology is self-organizing. nodes only need to be initialized


        #[hd, snd, thrd, frth, fifth | _tl] = Tapestry.DynamicSupervisor.start_children(num_nodes, [])
        #Tapestry.Server.join_from(frth, snd)
        #Tapestry.Server.join_from(thrd, snd)
        #Tapestry.Server.join_from(fifth, thrd)
        #Tapestry.Server.join_from(hd, snd)
        #Tapestry.Server.get_neighbors(hd) #Should have uid 2, 3, 4, 5 as neighbors
      _ ->
        IO.puts 'Invalid arguments please put args: numNodes numRequests'
    end
  end

  defp init_node(node) do
    #TODO: build out the DHT of new nodes coming on the network
    # 1.
    :ok
  end

  defp join_nodes([]), do: :ok
  defp join_nodes(list) do
    [h|t]=list
  end

end
