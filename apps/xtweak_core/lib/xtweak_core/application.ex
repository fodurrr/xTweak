defmodule XTweakCore.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      XTweak.Repo,
      {AshAuthentication.Supervisor, otp_app: :xtweak_core}
    ]

    opts = [strategy: :one_for_one, name: XTweakCore.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
