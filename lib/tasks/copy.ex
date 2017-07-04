defmodule PicoCD.Task.Copy do
    @moduledoc """
    A task for copying data between two given resources.
    """

    # The module name is just too long, create a scoped, friendlier alias
    alias PicoCD.Task, as: Task
    alias PicoCD.Task.Copy, as: Copy

    # We need to implement the PicoCD.Task behaviour in order to be usable
    # as a task
    @behaviour Task

    defstruct [:from, :to]

    def init({:cp, {from, to}}) do
        {:ok, %Copy{:from => from, :to => to}}
    end
    def init(_) do
        {:not_supported}
    end
end

defimpl PicoCD.UseTask, for: PicoCD.Task.Copy do
    
    # The module name is just too long, create a scoped, friendlier alias
    alias PicoCD.UseResource, as: Resource
    alias PicoCD.Task.Copy, as: Copy

    def run(%Copy{:from => from, :to => to}, resource_map) do
        IO.puts 'From #{IO.inspect from}'
        IO.puts 'To #{IO.inspect to}'

        resource_from = Map.get(resource_map, from)
        resource_to = Map.get(resource_map, to)

        object = Resource.read(resource_from)
        Resource.write(resource_to, object)

        {:ok, object}
    end
end
