defmodule PicoCD.Task do
    @callback init({atom, any}) :: {atom, any}

    def create(task_desc) do
        modules = [PicoCD.Task.Clear, PicoCD.Task.List, PicoCD.Task.Copy]
        
        lookup_and_create(task_desc, modules)
    end

    defp lookup_and_create(task_desc, [module | modules]) do
        result = apply(module, :init, [task_desc])

        case result do
            {:ok, task} -> task
            _ -> lookup_and_create(task_desc, modules)
        end
    end
    defp lookup_and_create(_task_desc, []) do
        nil
    end
end

defprotocol PicoCD.UseTask do
    def run(task, resource_map)
end
