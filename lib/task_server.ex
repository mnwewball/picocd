defmodule PicoCD.TaskServer do
    @moduledoc """

    """

    use GenServer

    require Logger

    @name PicoCD.TaskServer
    @worker_supervisor TaskWorkerSupervisor

    def start_link(resources) do
        Logger.debug "Starting TaskServer with associated resources #{inspect resources}"
        GenServer.start_link(__MODULE__, resources, name: @name)
    end

    def run_task(task) do
        Logger.debug "About to run task #{inspect task}"
        GenServer.call(@name, task)
    end

    def run_task_async(task) do
        Logger.debug "About to run async task #{inspect task}"
        GenServer.cast(@name, task)
    end

    def stop do
        Logger.debug "Stopping TaskServer"
        GenServer.stop(@name)
    end

    def init(resources) do
        resource_map = to_resource_map(resources, %{})

        {:ok, resource_map}
    end

    def handle_call(task_desc, _from_pid, resource_map) do
        {:reply, handle_request(task_desc, resource_map), resource_map} 
    end

    def handle_cast(task_desc, resource_map) do
        handle_request(task_desc, resource_map)
        {:noreply, resource_map}
    end

    def handle_info({:DOWN, _, :process, _pid, :normal}, resource_map) do
        {:reply, nil, resource_map}
    end
    def handle_info(request, resource_map) do
        super(request, resource_map)
    end

    defp handle_request(task_desc, resource_map) do
        task = create_task(task_desc)
        
        create_task_worker(task, resource_map)

        task
    end

    defp create_task(task_desc) do
        PicoCD.Task.create(task_desc)
    end

    defp create_task_worker(task, resource_map) do
        Task.Supervisor.start_child(@worker_supervisor, fn -> PicoCD.DefaultTaskWorker.run(task, resource_map) end)
    end

    defp to_resource_map([resource | resources], resource_map) do
        {:ok, name} = Map.fetch(resource, :name)
        to_resource_map(resources, Map.put(resource_map, name, resource))
    end
    defp to_resource_map([], resource_map) do
        resource_map
    end
end

defmodule PicoCD.TaskServer.Supervisor do
    use Supervisor

    @worker_supervisor TaskWorkerSupervisor

    def start_link(resources) do
        Supervisor.start_link(__MODULE__, resources)
    end

    def init(resources) do
        children = [
            # Must supervise the only task server 
            worker(PicoCD.TaskServer, [resources]),

            # Supervise the supervisor for all tasks. We need this supervisor
            # to always be alive
            supervisor(Task.Supervisor, [[name: @worker_supervisor, restart: :transient]]),

            Plug.Adapters.Cowboy.child_spec(:http, PicoCD.TaskServer.Router, [], [port: 4001])
        ]

        supervise(children, strategy: :one_for_one)
    end
end