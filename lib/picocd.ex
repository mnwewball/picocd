defmodule PicoCD do
  @moduledoc """
  Documentation for PicoCD.
  """

  use Application

  require Logger

  alias PicoCD.Resource.Filesystem, as: Filesystem
  alias PicoCD.TaskServer.Supervisor, as: TaskServerSupervisor
  alias PicoCD.TaskServer, as: TaskServer

  @resource1 'resource1'
  @resource2 'resource2'

  def main(_args) do
    task_server_pid = Process.whereis(PicoCD.TaskServer)
    Logger.info('Task Server: #{inspect task_server_pid}')
  end

  def start(_type, _args) do

    # Create two resources
    path1 = mk_dir()
    {:ok, resource1} = Filesystem.init(@resource1, %{:path => path1})
    Logger.info('#{@resource1}: #{inspect resource1}')

    path2 = mk_dir()
    {:ok, resource2} = Filesystem.init(@resource2, %{:path => path2})
    Logger.info('#{@resource2}: #{inspect resource2}')

    resources = [resource1, resource2]
    
    {:ok, supervisor_pid} = TaskServerSupervisor.start_link(resources)
    Logger.info('Supervisor: #{inspect supervisor_pid}')

    {:ok, supervisor_pid}
    
  end

  defp mk_dir() do
    path = '#{System.tmp_dir}/picocd_#{System.unique_integer([:positive])}'
    File.mkdir(path)

    path
  end

  # defp rm_dir(path) do
  #   File.rm_rf(path)
  # end
end
