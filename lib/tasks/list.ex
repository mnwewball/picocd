defmodule PicoCD.Task.List do
    @moduledoc """
    A task for listing a resource's contents.
    """

    # The module name is just too long, create a scoped, friendlier alias
    alias PicoCD.Task, as: Task
    alias PicoCD.Task.List, as: List

    # We need to implement the PicoCD.Task behaviour in order to be usable
    # as a task
    @behaviour Task

    defstruct [:resource]

    def init({:ls, resource}) do
        {:ok, %List{:resource => resource}}
    end
    def init(_) do
        {:not_supported}
    end
end

defimpl PicoCD.UseTask, for: PicoCD.Task.List do
    
    # The module name is just too long, create a scoped, friendlier alias
    alias PicoCD.UseResource, as: Resource
    alias PicoCD.Task.List, as: List

    def run(%List{:resource => resource_name}, resource_map) do
        IO.puts 'Resource #{resource_name}'

        resource = Map.get(resource_map, resource_name)

        Resource.list(resource)
    end
end