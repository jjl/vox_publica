defmodule VoxPublica.Web.LivePlugs.LoadSessionAuth do

  import Phoenix.LiveView
  alias VoxPublica.{Accounts, Users}

  def mount(%{"username" => username}, %{"account_id" => id}, socket),
    do: try_user(Users.get_for_session(username, id), socket)

  def mount(_, %{"account_id" => id}, socket),
    do: try_account(Accounts.get_for_session(id), socket)
    
  def mount(_, _, socket) do
    if connected?(socket),
      do: {:error, :not_permitted},
      else: {:ok, socket
      |> put_flash(:error, "You must log in to access this page.")
      |> redirect(to: "/login")}
  end

  defp try_user(nil, socket) do
    if connected?(socket),
      do: {:error, :not_permitted},
      else: {:ok, socket
      |> put_flash(:error, "You do not have permission to become this user.")
      |> redirect(to: "/_")}
  end

  defp try_user(user, socket),
    do: {:ok, socket
    |> assign(current_user: user, current_account: user.accounted.account)}

  defp try_account(nil, socket) do
    if connected?(socket),
      do: {:error, :not_permitted},
      else: {:ok, socket
      |> put_flash(:error, "You must log in to access this page.")
      |> redirect(to: "/login")}
  end

  defp try_account(account, socket),
    do: {:ok, socket
    |> assign(current_user: nil, current_account: account)}

end
