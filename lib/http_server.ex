defmodule PicoCD.TaskServer.Router do
    use Plug.Router
    require Logger

    alias PicoCD.TaskServer, as: TaskServer

    @resource1 'resource1'
    @resource2 'resource2'

    plug Plug.Logger
    plug :match
    plug :dispatch

    get "/bu" do

        res = TaskServer.run_task({:cp, {@resource1, @resource2}})
        Logger.info('Copy #{inspect res}')

        res = TaskServer.run_task({:ls, @resource1})
        Logger.info('List #{inspect res}')

        res = TaskServer.run_task({:clear, @resource1})
        Logger.info('Clear #{inspect res}')

        res = TaskServer.run_task({:ls, @resource1})
        Logger.info('List #{inspect res}')

        conn
        |> send_resp(200, 'Up')
    end

    match _ do
        send_resp(conn, 404, "oops")
    end
end