defmodule VoxPublica.Application do
  @moduledoc false

  @sup_name VoxPublica.Supervisor

  use Application

  def start(_type, _args) do
    [
      Pointers.Tables,
      VoxPublica.Web.Telemetry,
      VoxPublica.Repo,
      {Phoenix.PubSub, name: VoxPublica.PubSub},
      VoxPublica.Web.Endpoint,
      {Oban, Application.get_env(:vox_publica, Oban)}
    ]
    |> Supervisor.start_link(strategy: :one_for_one, name: @sup_name)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    VoxPublica.Web.Endpoint.config_change(changed, removed)
    :ok
  end

end
