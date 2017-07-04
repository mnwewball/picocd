defmodule PicoCD.ConsoleLogger do
    use GenEvent

    def handle_event({:log, {:info, time, message}}, _) do
        create_log('INFO', time, message) |> IO.puts
        {:ok, nil}
    end
    def handle_event({:log, {:warning, time, message}}, _) do
        create_log('WARN', time, message) |> IO.puts
        {:ok, nil}
    end
    def handle_event({:log, {:error, time, message}}, _) do
        create_log('ERROR', time, message) |> IO.puts
        {:ok, nil}
    end
    def handle_event(error, _) do
        create_log('ERROR', DateTime.utc_now(), '#{inspect error}')
        {:ok, nil}
    end

    def terminate(_, _) do
        IO.puts('Terminating ConsoleLogger')
        :remove_handler
    end

    defp create_log(level, time, message) do
        'ConsoleLogger - #{level}: [#{DateTime.to_string time}] #{message}'
    end
end

defmodule PicoCD.ANSIConsoleLogger do
    use GenEvent

    def handle_event({:log, {:info, time, message}}, _) do
        create_log('INFO', time, message) |> IO.puts
        {:ok, nil}
    end
    def handle_event({:log, {:warning, time, message}}, _) do
        create_log('WARN', time, message) |> IO.puts
        {:ok, nil}
    end
    def handle_event({:log, {:error, time, message}}, _) do
        create_log('ERROR', time, message) |> IO.puts
        {:ok, nil}
    end
    def handle_event(error, _) do
        create_log('ERROR', DateTime.utc_now(), '#{inspect error}')
        {:ok, nil}
    end

    def terminate(_, _) do
        IO.puts('Terminating ANSIConsoleLogger')
        :remove_handler
    end

    defp create_log(level, time, message) do
        line = [
            :yellow, :bright, 'ANSIConsoleLogger', 
            :reset, :white, ' - ', 
            :yellow, :bright, '#{level}', 
            :reset, :white, ': ', 
            :cyan, :bright, '[#{DateTime.to_string time}] ', 
            :white, :bright, '#{message}'
        ]

        line |> IO.ANSI.format
    end
end