defmodule VoxPublica.Web.Router do
  use VoxPublica.Web, :router
  use ActivityPubWeb.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {VoxPublica.Web.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :guest_only do
    plug VoxPublica.Web.Plugs.GuestOnly
  end

  # visible to everyone
  scope "/", VoxPublica.Web do
    pipe_through :browser
    live "/", IndexLive, :index
    live "/users/@:username", ProfileLive, :profile
    live "/users/@:username/:tab", ProfileLive, :profile_tab
  end

  # visible only to guests
  scope "/", VoxPublica.Web do
    pipe_through :browser
    pipe_through :guest_only
    # guest visible pages
    resources "/confirm-email", ConfirmEmailController, only: [:index, :show, :create]
    resources "/signup", SignupController, only: [:index, :create]
    resources "/login", LoginController, only: [:index, :create]
    resources "/forgot-password/", ForgotPasswordController, only: [:index, :create]
    resources "/reset-password/:token", ResetPasswordController, only: [:index, :create]
  end

  # visible only to users and account holders
  scope "/_", VoxPublica.Web do
    pipe_through :browser
    live "/", SwitchUserLive
    live "/change-password", ChangePasswordLive
    live "/create-user", CreateUserLive, only: [:index, :create]

    scope "/@:username" do
      live "/home", HomeLive, :home
      live "/settings", SettingsLive, :settings
      live "/settings/:tab", SettingsLive, :settings_tab
    end
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: VoxPublica.Web.Telemetry
      forward "/emails", Bamboo.SentEmailViewerPlug
    end
  end
end
