defmodule Blog.LayoutViewTest do
  require IEx
  use Blog.ConnCase, async: false

  alias Blog.User
  alias Blog.LayoutView

  setup do
    User.changeset(%User{}, %{username: "test", password: "test", password_confirmation: "test", email: "test@test.com"})
    |> Repo.insert
    
    {:ok, conn: conn()}
  end

  test "current user returns the user in session", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: %{username: "test", password: "test"}
    assert LayoutView.current_user(conn)
  end

  test "current user returns nothing if there is no user in the session" do
    user = Repo.get_by(User, %{username: "test"})
    # user = Repo.one(from u in User, where: u.username == "test", limit: 1)
    conn = delete conn, session_path(conn, :delete, user)
    refute LayoutView.current_user(conn)
  end

  test "deletes the user session", %{conn: conn} do
    user = Repo.get_by(User, %{username: "test"})
    conn = delete conn, session_path(conn, :delete, user)
    refute get_session(conn, :current_user)

    assert get_flash(conn, :info) == "Signed out successfully!"
    assert redirected_to(conn) == page_path(conn, :index)
  end
end
