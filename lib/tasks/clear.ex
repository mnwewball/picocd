defmodule PicoCD.Task.Clear do
    @moduledoc """
    A task for clearing a resource.
    """

    # The module name is just too long, create a scoped, friendlier alias
    alias PicoCD.Task, as: Task
    alias PicoCD.Task.Clear, as: Clear

    # We need to implement the PicoCD.Task behaviour in order to be usable
    # as a task
    @behaviour Task

    defstruct [:resource]

    def init({:clear, resource}) do
        {:ok, %Clear{:resource => resource}}
    end
    def init(_) do
        {:not_supported}
    end
end

defimpl PicoCD.UseTask, for: PicoCD.Task.Clear do
    
    # The module name is just too long, create a scoped, friendlier alias
    alias PicoCD.UseResource, as: Resource
    alias PicoCD.Task.Clear, as: Clear

    def run(%Clear{:resource => resource_name}, resource_map) do
        IO.puts 'Resource #{resource_name}'

        resource = Map.get(resource_map, resource_name)

        Resource.clear(resource)
    end
end