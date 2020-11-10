defmodule VoxPublica.Repo.Migrations.ImportWorld do
  use Ecto.Migration
  import Pointers.Migration
  import CommonsPub.Accounts.Account.Migration
  import CommonsPub.Accounts.Accounted.Migration
  import CommonsPub.Access.Access.Migration
  import CommonsPub.Access.AccessGrant.Migration
  import CommonsPub.Acls.Acl.Migration
  import CommonsPub.Acls.AclGrant.Migration
  import CommonsPub.Actors.Actor.Migration
  import CommonsPub.Characters.Character.Migration
  import CommonsPub.Circles.Circle.Migration
  import CommonsPub.Circles.Encircle.Migration
  import CommonsPub.Emails.Email.Migration
  import CommonsPub.LocalAuth.LoginCredential.Migration
  import CommonsPub.Profiles.Profile.Migration
  import CommonsPub.Users.User.Migration
  alias CommonsPub.Access.Access

  def up do
    migrate_circle()
    migrate_encircle()
    create_access_table do
      add :can_see, :boolean
    end
    migrate_access_grant()
    create_acl_table do
      add :guest_access_id, strong_pointer(Access), null: false
      add :local_user_access_id, strong_pointer(Access), null: false
    end
    migrate_acl_grant()

    migrate_account()
    migrate_accounted()
    migrate_email()
    migrate_login_credential()

    migrate_user()
    migrate_character()
    migrate_profile()
    migrate_actor()
  end

  def down do
    migrate_actor()
    migrate_profile()
    migrate_character()

    migrate_user()
    migrate_login_credential()
    migrate_email()
    migrate_accounted()
    migrate_account()

    migrate_acl_grant()
    drop_acl_table()
    migrate_access_grant()
    drop_access_table()
    migrate_encircle()
    migrate_circle()
  end

end
