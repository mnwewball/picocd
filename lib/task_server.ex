defmodule PicoCD.TaskServer do
    use GenServer

    @name PicoCD.TaskServer
    @logger Logger
    @worker Worker

    def start_link(resources) do
        GenServer.start_link(__MODULE__, resources, name: @name)
    end

    def run_task(task) do
        IO.puts('Attempting #{inspect task}')
        GenServer.call(@name, task)
    end

    def run_task_async(task) do
        IO.puts('Attempting #{inspect task}')
        GenServer.cast(@name, task)
    end

    def stop do
        GenServer.stop(@name)
    end

    def init(resources) do
        GenEvent.start_link(name: @logger)
        GenEvent.add_handler(@logger, PicoCD.ConsoleLogger, nil)
        GenEvent.add_handler(@logger, PicoCD.ANSIConsoleLogger, nil)

        GenEvent.start_link(name: @worker)
        GenEvent.add_handler(@worker, PicoCD.EventTaskWorker, nil)

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

    def handle_info({:DOWN, _, :process, pid, :normal}, resource_map) do
        IO.puts('Process #{inspect pid} going DOWN')
        {:reply, nil, resource_map}
    end
    def handle_info(request, resource_map) do
        super(request, resource_map)
    end

    defp handle_request(task_desc, resource_map) do
        task = create_task(task_desc)
        GenEvent.sync_notify(@logger, {:log, {:info, DateTime.utc_now(), 'Task created #{inspect task}'}})

        GenEvent.sync_notify(@logger, {:log, {:info, DateTime.utc_now(), 'Creating worker for task #{inspect task}'}})
        create_event_worker(task, resource_map)
        create_task_worker(task, resource_map)
        GenEvent.sync_notify(@logger, {:log, {:info, DateTime.utc_now(), 'Worker created for task #{inspect task}'}})

        task
    end

    defp create_task(task_desc) do
        PicoCD.Task.create(task_desc)
    end

    defp create_event_worker(task, resource_map) do
        GenEvent.notify(@worker, {:run, task, resource_map})
    end

    defp create_task_worker(task, resource_map) do
        worker_task = Task.async(fn -> PicoCD.DefaultTaskWorker.run(task, resource_map) end)
        #Task.await(worker_task)
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

    def start_link(resources) do
        Supervisor.start_link(__MODULE__, resources)
    end

    def init(resources) do
        children = [
            worker(PicoCD.TaskServer, [resources])
        ]

        supervise(children, strategy: :one_for_one)
    end
end