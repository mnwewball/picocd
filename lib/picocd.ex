defmodule PicoCD do
  @moduledoc """
  Documentation for PicoCD.
  """

  def init_plain do
    # Create two resources
    path1 = new_tmp_dir()
    path2 = new_tmp_dir()

    {:ok, resource1} = PicoCD.Resource.Filesystem.init('From', %{:path => path1})
    {:ok, resource2} = PicoCD.Resource.Filesystem.init('To', %{:path => path2})
    IO.puts('#{inspect resource1}')
    IO.puts('#{inspect resource2}')

    {:ok, pid} = GenServer.start_link(PicoCD.TaskServer, [resource1, resource2])

    res1 = GenServer.call(pid, :copy)
    IO.puts('Res1 #{inspect res1}')

    res2 = GenServer.cast(pid, :copy)
    IO.puts('Res2 #{inspect res2}')
    
    GenServer.stop(pid)

    res3 = clean_dir(path1)
    IO.puts('#{inspect res3}')
    res4 = clean_dir(path2)
    IO.puts('#{inspect res4}')
  end

  def init_with_monitor do
    # Create two resources
    path1 = new_tmp_dir()
    path2 = new_tmp_dir()

    {:ok, resource1} = PicoCD.Resource.Filesystem.init('From', %{:path => path1})
    {:ok, resource2} = PicoCD.Resource.Filesystem.init('To', %{:path => path2})
    IO.puts('#{inspect resource1}')
    IO.puts('#{inspect resource2}')

    {:ok, pid} = GenServer.start_link(PicoCD.TaskServer, [resource1, resource2])
    reference = Process.monitor(pid)

    IO.puts('#{inspect reference}')

    res1 = GenServer.call(pid, :copy)
    IO.puts('Res1 #{inspect res1}')

    res2 = GenServer.cast(pid, :copy)
    IO.puts('Res2 #{inspect res2}')
    
    GenServer.stop(pid)

    res3 = clean_dir(path1)
    IO.puts('#{inspect res3}')
    res4 = clean_dir(path2)
    IO.puts('#{inspect res4}')
  end

  def init_with_supervisor do
    PicoCD.Supervisor.start_link
  end

  defp new_tmp_dir() do
    path = '#{System.tmp_dir}/picocd_#{System.unique_integer([:positive])}'
    File.mkdir(path)

    path
  end

  defp clean_dir(path) do
    File.rm_rf(path)
  end
end

defmodule PicoCD.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(PicoCD.TaskServer, [PicoCD.TaskServer])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
