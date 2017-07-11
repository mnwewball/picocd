defmodule PicoCD.DefaultTaskWorker do
    
    alias PicoCD.UseTask, as: UseTask
    
    require Logger

    def run(task, resource_map) do
        Logger.debug "WORKER - #{task}"
        task |> UseTask.run(resource_map)
    end
end
