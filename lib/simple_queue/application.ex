defmodule SimpleQueue.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    
    #Opções do Supervisor
    opts = [
      strategy: :one_for_one, 
      name: SimpleQueue.Supervisor
    ]

    case DynamicSupervisor.start_link(opts) do
      {:ok, _pid} ->
        #initial_list = [1,2,3]
        #{:ok, pid} = DynamicSupervisor.start_child(SimpleQueue.Supervisor, {SimpleQueue, initial_list})
        {:ok, pid} = DynamicSupervisor.start_child(SimpleQueue.Supervisor, SimpleQueue)
        {:ok, pid}

      {:error, reason} ->
        {:error, reason}
    end
  end

end
