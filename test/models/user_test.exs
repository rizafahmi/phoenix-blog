defmodule Blog.UserTest do
  use Blog.ModelCase

  alias Blog.User

  @valid_attrs %{email: "test@test.com", password: "test1234", password_confirmation: "test1234", username: "testuser"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    IO.inspect @valid_attrs
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
