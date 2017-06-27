defmodule PicoCD.Task.Copy do
    @moduledoc """
    A task for copying data between two given resources.
    """

    # The module name is just too long, create a scoped, friendlier alias
    alias PicoCD.Task, as: Task
    alias PicoCD.UseResource, as: Resource

    # We need to implement the PicoCD.Task behaviour in order to be usable
    # as a task
    @behaviour Task

    def init(name, %{:from => from, :to => to}) do
        {:ok, %Task{:name => name, :params => %{:from => from, :to => to}}}
    end

    def run(%Task{:params => %{:from => from, :to => to}}, _) do
        IO.puts 'From #{IO.inspect from}'
        IO.puts 'To #{IO.inspect to}'

        object = Resource.read(from)
        Resource.write(to, object)

        {:ok, object}
    end
end