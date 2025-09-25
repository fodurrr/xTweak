import Config

# Configure the database for testing
config :xtweak_core, XTweak.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "xtweak_test",
  port: 5432,
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :xtweak_web, XTweakWebWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Zdj3BlzXO80HZJ1M9oGbPHrOmVUI0AdT4lmqbTRq+BzH7t4zSRb+1f4YsresRCzG",
  server: false

# In test we don't send emails
config :xtweak_web, XTweakWeb.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

# Ash testing configuration
config :ash, :disable_async?, true
config :ash, :missed_notifications, :ignore

# AshAuthentication token signing secret for testing
config :xtweak_core, :token_signing_secret, "test_secret_for_token_signing"

# Libcluster configuration removed - no longer needed for template
