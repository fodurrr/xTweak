defmodule XTweak.Core.UserTest do
  use XTweak.DataCase
  alias XTweak.Core.User

  describe "user creation" do
    test "creates a user with valid attributes" do
      assert {:ok, user} =
               User
               |> Ash.Changeset.for_create(:register_with_password, %{
                 email: "test@example.com",
                 password: "ValidPassword123!"
               })
               |> Ash.create()

      assert to_string(user.email) == "test@example.com"
      assert user.role == :user
    end

    test "fails with invalid email" do
      assert {:error, error} =
               User
               |> Ash.Changeset.for_create(:register_with_password, %{
                 email: "invalid",
                 password: "ValidPassword123!"
               })
               |> Ash.create()

      assert %Ash.Error.Invalid{} = error
      # Check that the email validation error is present
      assert Enum.any?(error.errors, fn err ->
               match?(%Ash.Error.Changes.InvalidAttribute{field: :email}, err)
             end)
    end
  end
end
