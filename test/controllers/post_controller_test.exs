defmodule Blog.PostControllerTest do
  use Blog.ConnCase

  alias Blog.Post
  alias Blog.User

  @valid_attrs %{body: "some content", title: "some content"}
  @invalid_attrs %{}

  setup do
    {:ok, user} = create_user
    conn = conn()
    |> login_user(user)
    {:ok, conn: conn, user: user}
  end

  test "lists all entries on index", %{conn: conn, user: user} do
    conn = get conn, user_post_path(conn, :index, user)
    assert html_response(conn, 200) =~ "Listing posts"
  end

  test "renders form for new resources", %{conn: conn, user: user} do
    conn = get conn, user_post_path(conn, :new, user)
    assert html_response(conn, 200) =~ "New post"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, user: user} do
    conn = post conn, user_post_path(conn, :create, user), post: @valid_attrs
    assert redirected_to(conn) == user_post_path(conn, :index, user)
    assert Repo.get_by(assoc(user, :posts), @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, user: user} do
    conn = post conn, user_post_path(conn, :create, user), post: @invalid_attrs
    assert html_response(conn, 200) =~ "New post"
  end

  test "shows chosen resource", %{conn: conn, user: user} do
    post = build_post(user)
    conn = get conn, user_post_path(conn, :show, post, user)
    assert html_response(conn, 200) =~ "Show post"
  end

  test "renders page not found when id is nonexistent", %{conn: conn, user: user} do
    assert_raise Ecto.NoResultError, fn ->
      get conn, user_post_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, user: user} do
    post = build_post(user)
    conn = get conn, user_post_path(conn, :edit, user, post)
    assert html_response(conn, 200) =~ "Edit post"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user} do
    post = build_post(user)
    conn = put conn, user_post_path(conn, :update, user, post), post: @valid_attrs
    assert redirected_to(conn) == user_post_path(conn, :show, user, post)
    assert Repo.get_by(Post, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
    post = build_post(user)
    conn = put conn, user_post_path(conn, :update, user, post), post: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit post"
  end

  # test "deletes chosen resource", %{conn: conn, user: user} do
  #   post = build_post(user)
  #   conn = delete conn, user_post_path(conn, :delete, user, post)
  #   assert redirected_to(conn) == user_post_path(conn, :index, user)
  #   refute Repo.get(Post, post.id)
  # end

  defp create_user do
    User.changeset(%User{}, %{email: "test@test.com", username: "test", password: "test", password_confirmation: "test"})
    |> Repo.insert
  end

  defp login_user(conn, user) do
    post conn, session_path(conn, :create), user: %{username: user.username, password: user.password}
  end

  defp build_post(user) do
    changeset =
      user
      |> build_assoc(:posts)
      |> Post.changeset(@valid_attrs)

    Repo.insert!(changeset)
  end
end
