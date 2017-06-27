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

    def init(name, %{:from => from, :to => to}) do
        {:ok, %Task{:name => name, :params => %Copy{:from => from, :to => to}}}
    end
end

defimpl PicoCD.UseTask, for: PicoCD.Task.Copy do
    
    alias PicoCD.UseResource, as: Resource
    alias PicoCD.Task.Copy, as: Copy

    def run(%Copy{:from => from, :to => to}, name) do
        IO.puts 'Running task #{name}'
        IO.puts 'From #{inspect from}'
        IO.puts 'To #{inspect to}'

        object = Resource.read(from)
        Resource.write(to, object)

        {:ok, object}
    end
end