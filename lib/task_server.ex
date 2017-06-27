defmodule PicoCD.TaskServer do
    use GenServer

    def start_link(name) do
        GenServer.start_link(__MODULE__, :ok, name: name)
    end
    
    def handle_call(:copy, _, resources = [from, to]) do
        {:ok, task} = PicoCD.Task.Copy.init('Name', %{:from => from, :to => to})
        IO.puts('Task created: #{inspect task}')

        %{:name => name, :params => task_params} = task

        PicoCD.UseTask.run(task_params, name)
        {:reply, resources, resources}
    end
    def handle_call(request, from, resources) do
        super(request, from, resources)
    end

    def handle_cast(:copy, resources) do
        {:noreply, resources}
    end
    def handle_cast(request, resources) do
       super(request, resources) 
    end
end