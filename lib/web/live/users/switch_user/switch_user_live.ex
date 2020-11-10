defmodule VoxPublica.Web.SwitchUserLive do
  use VoxPublica.Web, :live_view
  alias VoxPublica.Fake
  alias VoxPublica.Web.LivePlugs

  def mount(params, session, socket) do
    LivePlugs.live_plug params, session, socket, [
      LivePlugs.LoadSessionAuth,
      LivePlugs.StaticChanged,
      LivePlugs.Csrf,
      LivePlugs.AuthRequired,
      &mounted/3,
    ]
  end

  defp mounted(params, session, socket),
    do: {:ok, socket
    |> assign(page_title: "Switch User", selected_tab: "about", users: [])}

  # def handle_params(%{"tab" => tab} = _params, _url, socket) do
  #   {:noreply,
  #    assign(socket,
  #      selected_tab: tab
  #    )}
  # end

  # def handle_params(%{} = _params, _url, socket) do
  #   {:noreply,
  #    assign(socket,
  #      current_user: Fake.user_live()
  #    )}
  # end

end
