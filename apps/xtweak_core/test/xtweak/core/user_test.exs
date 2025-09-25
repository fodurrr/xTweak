defmodule XTweak.Core.UserTest do
  use XTweak.DataCase
  alias XTweak.Core
  alias XTweak.Core.User

  describe "user creation" do
    test "creates a user with valid attributes" do
      assert {:ok, user} =
               User
               |> Ash.Changeset.for_create(:register_with_password, %{
                 email: "test@example.com",
                 password: "ValidPassword123!",
                 password_confirmation: "ValidPassword123!"
               })
               |> Core.create()

      assert user.email == "test@example.com"
      assert user.role == :user
    end

    test "fails with invalid email" do
      assert {:error, changeset} =
               User
               |> Ash.Changeset.for_create(:register_with_password, %{
                 email: "invalid",
                 password: "ValidPassword123!",
                 password_confirmation: "ValidPassword123!"
               })
               |> Core.create()

      assert %{email: ["must have the @ sign and no spaces"]} = errors_on(changeset)
    end
  end
end
