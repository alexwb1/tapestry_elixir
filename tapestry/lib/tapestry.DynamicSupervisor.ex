defmodule Tapestry.DynamicSupervisor do
  use DynamicSupervisor

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def start_child(id_num) do
    spec = %{id: id_num, start: {Tapestry.Server, :start_link, [id_num]}}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def init(_args) do
    DynamicSupervisor.init(
      strategy: :one_for_one # If you stop, I'll replace you
    )
  end

  def count_children do
    DynamicSupervisor.count_children(__MODULE__)
  end

  def terminate_child(pid) do
    DynamicSupervisor.terminate_child(__MODULE__, pid)
  end

  def create_workers(list, 0) do list end
  def create_workers(list, num) do
    agent = start_child(num)
    case agent do
      {:ok, pid} ->
        newlist = [pid | list]
        num = num - 1
        create_workers(newlist, num)
      other ->
        other
    end
  end

  def start_children(0, list) do
    list
  end
  def start_children(num_children, list) do
    uuid = num_children
    # Assume Base 16 hash, hashes are 16 bytes wide, DHTs are 16 bytes deep
    {guid, _} = String.split_at(String.downcase(Base.encode16(:crypto.hash(:sha, "whatever #{uuid}"))), 16)
    {:ok, pid} = start_child(guid)
    list = [%{uid: guid, pid: pid} | list]
    start_children(num_children - 1, list)
  end

end
