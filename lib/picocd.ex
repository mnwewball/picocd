defmodule PicoCD do
  @moduledoc """
  Documentation for PicoCD.
  """

  use Application

  alias PicoCD.Resource.Filesystem, as: Filesystem
  alias PicoCD.TaskServer.Supervisor, as: TaskServerSupervisor
  alias PicoCD.TaskServer, as: TaskServer

  def start(_type, _args) do

    IO.puts(
      ~s"""


      Initializing:
      -------------

      """)

    # Create two resources
    path1 = mk_dir()
    name1 = 'resource1'
    {:ok, resource1} = Filesystem.init(name1, %{:path => path1})
    IO.puts('#{name1}: #{inspect resource1}')

    path2 = mk_dir()
    name2 = 'resource2'
    {:ok, resource2} = Filesystem.init(name2, %{:path => path2})
    IO.puts('#{name2}: #{inspect resource2}')

    resources = [resource1, resource2]
    
    {:ok, supervisor_pid} = TaskServerSupervisor.start_link(resources)
    IO.puts('Supervisor: #{inspect supervisor_pid}')

    supervised_children = Supervisor.which_children(supervisor_pid)
    IO.puts('Supervised: #{inspect supervised_children}')

    task_server_pid = Process.whereis(PicoCD.TaskServer)
    IO.puts('Task Server: #{inspect task_server_pid}')

    IO.puts(
      ~s"""


      Copy from #{name1} to #{name2} and then clear #{name1}:
      ----------------------------------------------------------

      """)

    res = TaskServer.run_task({:cp, {name1, name2}})
    IO.puts('Copy #{inspect res}')

    res = TaskServer.run_task({:ls, name1})
    IO.puts('List #{inspect res}')

    res = TaskServer.run_task({:clear, name1})
    IO.puts('Clear #{inspect res}')

    res = TaskServer.run_task({:ls, name1})
    IO.puts('List #{inspect res}')

    IO.puts(
      ~s"""


      Copy from #{name2} to #{name1} and then clear #{name2}:
      ----------------------------------------------------------

      """)

    res = TaskServer.run_task_async({:cp, {name2, name1}})
    IO.puts('Copy #{inspect res}')

    res = TaskServer.run_task_async({:ls, name2})
    IO.puts('List #{inspect res}')

    res = TaskServer.run_task_async({:clear, name2})
    IO.puts('Clear #{inspect res}')

    res = TaskServer.run_task_async({:ls, name2})
    IO.puts('List #{inspect res}')
    
    IO.puts(
      ~s"""


      Cleaning up:
      ------------

      """)

    IO.puts('Stopping task server')
    TaskServer.stop()

    IO.puts('Removing #{name1}:')
    res = rm_dir(path1)
    IO.puts('#{inspect res}')
    
    IO.puts('Removing #{name2}:')
    res = rm_dir(path2)
    IO.puts('#{inspect res}')
    
  end

  defp mk_dir() do
    path = '#{System.tmp_dir}/picocd_#{System.unique_integer([:positive])}'
    File.mkdir(path)

    path
  end

  defp rm_dir(path) do
    File.rm_rf(path)
  end
end
