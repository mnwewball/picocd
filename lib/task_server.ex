defmodule PicoCD.TaskServer do
    use GenServer

    def start_link(name) do
        GenServer.start_link(__MODULE__, :ok, name: name)
    end
    
    def handle_call(:copy, _, resources) do
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