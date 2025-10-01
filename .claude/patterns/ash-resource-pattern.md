# Ash Resource Pattern Template

## Pattern Purpose
Defines the standard structure for Ash Framework resources in umbrella applications.

## Phase 0: Detect Project Context FIRST

Before using this pattern, detect actual project structure:

```bash
# 1. Detect app names
ls apps/
# Store: {detected_core_app}, {detected_web_app}

# 2. Detect domain pattern
mcp__ash_ai__list_ash_resources
# Look for: Blog.Domain, XTweak.Core, Shop.Domain
# Store: {detected_domain}

# 3. Verify domain module
mcp__tidewave__project_eval code: "h {DetectedDomain}"
```

## Generic Pattern (Adapt to YOUR Project)

```elixir
defmodule {YourApp}.{Domain}.{ResourceName} do
  @moduledoc """
  {ResourceName} resource description...
  """

  use Ash.Resource,
    domain: {YourApp}.{Domain},           # Replace with detected domain
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]     # Optional

  postgres do
    table "{resource_table_name}"
    repo {YourApp}.Repo                   # Replace with detected repo

    references do
      # Define foreign key behaviors
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
      constraints min_length: 1, max_length: 255
    end

    timestamps()
  end

  relationships do
    # belongs_to, has_many, has_one, many_to_many
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      accept [:name]
    end

    update :update do
      accept [:name]
    end
  end

  policies do
    policy action_type(:read) do
      authorize_if always()
    end

    policy action_type([:create, :update, :destroy]) do
      authorize_if actor_attribute_equals(:role, :admin)
    end
  end
end
```

## Example for "Blog" Project

```elixir
defmodule Blog.Domain.Post do
  @moduledoc """
  Post resource for blog articles.
  """

  use Ash.Resource,
    domain: Blog.Domain,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "posts"
    repo Blog.Repo
  end

  attributes do
    uuid_primary_key :id

    attribute :title, :string do
      allow_nil? false
      constraints min_length: 1, max_length: 255
    end

    attribute :body, :string do
      allow_nil? false
    end

    attribute :status, :atom do
      allow_nil? false
      default :draft
      constraints one_of: [:draft, :published, :archived]
    end

    timestamps()
  end

  relationships do
    belongs_to :author, Blog.Domain.User do
      allow_nil? false
      attribute_writable? true
    end
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      accept [:title, :body, :author_id]
    end

    update :update do
      accept [:title, :body, :status]
    end

    update :publish do
      accept []
      change set_attribute(:status, :published)
    end
  end

  policies do
    policy action_type(:read) do
      authorize_if always()
    end

    policy action_type([:create, :update, :destroy]) do
      authorize_if relates_to_actor_via(:author)
    end
  end
end
```

## Example for "Shop" Project

```elixir
defmodule Shop.Domain.Product do
  @moduledoc """
  Product resource for e-commerce catalog.
  """

  use Ash.Resource,
    domain: Shop.Domain,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "products"
    repo Shop.Repo
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
      constraints min_length: 1, max_length: 255
    end

    attribute :price, :decimal do
      allow_nil? false
      constraints min: 0
    end

    attribute :status, :atom do
      allow_nil? false
      default :active
      constraints one_of: [:active, :inactive, :archived]
    end

    timestamps()
  end

  relationships do
    belongs_to :category, Shop.Domain.Category do
      allow_nil? true
      attribute_writable? true
    end

    has_many :order_items, Shop.Domain.OrderItem
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      accept [:name, :price, :category_id]
    end

    update :update do
      accept [:name, :price, :status, :category_id]
    end
  end

  policies do
    policy action_type(:read) do
      authorize_if always()
    end

    policy action_type([:create, :update, :destroy]) do
      authorize_if actor_attribute_equals(:role, :admin)
    end
  end
end
```

## Usage Instructions

1. **Detect** your project structure (Phase 0)
2. **Replace** ALL placeholders with detected values:
   - `{YourApp}` → Your project name (Blog, XTweak, Shop, etc.)
   - `{Domain}` → Your domain module suffix (Domain, Core, etc.)
   - `{ResourceName}` → Your specific resource (Post, User, Product, etc.)
3. **Adapt** table names, attributes, relationships to your needs
4. **Verify** with `mcp__tidewave__project_eval` before claiming success

## Key Points

- **Never** use "MyApp" literally
- **Always** specify domain in `use Ash.Resource`
- **Always** define policies for authorization
- **Use** generators when available: `mix ash.gen.resource`
- **Verify** generated migrations: `mix ash_postgres.generate_migrations --check`
