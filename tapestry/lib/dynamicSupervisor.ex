defmodule Tapestry.DynamicSupervisor do
  use DynamicSupervisor

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    DynamicSupervisor.init(
      strategy: :one_for_one
    )
  end

  def start_child(id_num) do
    spec = %{id: id_num, start: {Tapestry.Server, :start_link, [id_num]}}
    DynamicSupervisor.start_child(__MODULE__, spec)
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
