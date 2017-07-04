defmodule PicoCD.EventTaskWorker do
    use GenEvent

    alias PicoCD.UseTask, as: UseTask

    @logger Logger

    def handle_event({:run, task, resource_map}, _) do
        GenEvent.sync_notify(@logger, {:log, {:info, DateTime.utc_now(), 'ETW - Starting task #{inspect task} with resource map #{inspect resource_map}'}})
        UseTask.run(task, resource_map)
        GenEvent.sync_notify(@logger, {:log, {:info, DateTime.utc_now(), 'ETW - Task ran successfully! #{inspect task}'}})
        {:ok, nil}
    end
    def handle_event(_, _) do
        {:ok, nil}
    end

    def handle_info(_, _) do
        {:ok, nil}
    end

    def terminate(_, _) do
        IO.puts('Terminating EventTaskWorker')
        :remove_handler
    end
end

defmodule PicoCD.DefaultTaskWorker do
    
    alias PicoCD.UseTask, as: UseTask

    @logger Logger

    def run(task, resource_map) do
        GenEvent.sync_notify(@logger, {:log, {:info, DateTime.utc_now(), 'DTW - Starting task #{inspect task} with resource map #{inspect resource_map}'}})
        UseTask.run(task, resource_map)
        GenEvent.sync_notify(@logger, {:log, {:info, DateTime.utc_now(), 'DTW - Task ran successfully! #{inspect task}'}})
        {:ok, nil}
    end
end
