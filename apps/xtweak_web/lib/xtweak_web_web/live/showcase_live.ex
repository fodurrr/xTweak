defmodule XTweakWebWeb.ShowcaseLive do
  use XTweakWebWeb, :live_view
  alias XTweakUI.Components.Alert
  alias XTweakUI.Components.Avatar
  alias XTweakUI.Components.Badge
  alias XTweakUI.Components.Button
  alias XTweakUI.Components.Card
  alias XTweakUI.Components.Divider

  def mount(_params, _session, socket) do
    {:ok, assign(socket, theme: "light", page_title: "xTweak UI Showcase")}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-ui-bg-default" phx-hook="UniversalTheme" id="theme-container">
      <!-- Header -->
      <header class="border-b border-ui-border-default bg-ui-bg-elevated">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div class="flex items-center justify-between">
            <div>
              <h1 class="text-2xl font-bold text-ui-text-default">xTweak UI</h1>
              <p class="text-sm text-ui-text-muted">Component Library for Phoenix LiveView</p>
            </div>
            
    <!-- Theme Switcher -->
            <button
              phx-click="toggle_theme"
              class="px-4 py-2 rounded-lg bg-ui-bg-accented text-ui-text-default hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors"
            >
              {if @theme == "light", do: "🌙 Dark", else: "☀️ Light"}
            </button>
          </div>
        </div>
      </header>
      
    <!-- Main Content -->
      <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="space-y-12">
          <!-- Button Component Section -->
          <section>
            <h2 class="text-3xl font-bold text-ui-text-default mb-2">Button</h2>
            <p class="text-ui-text-dimmed mb-8">
              Button component with multiple variants, sizes, and states.
            </p>
            
    <!-- Variants -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Variants</h3>
              <div class="flex flex-wrap gap-4">
                <Button.button variant="solid">Solid</Button.button>
                <Button.button variant="outline">Outline</Button.button>
                <Button.button variant="soft">Soft</Button.button>
                <Button.button variant="ghost">Ghost</Button.button>
                <Button.button variant="link">Link</Button.button>
              </div>
            </div>
            
    <!-- Colors -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Colors</h3>
              <div class="flex flex-wrap gap-4">
                <Button.button color="primary">Primary</Button.button>
                <Button.button color="secondary">Secondary</Button.button>
                <Button.button color="success">Success</Button.button>
                <Button.button color="warning">Warning</Button.button>
                <Button.button color="error">Error</Button.button>
                <Button.button color="neutral">Neutral</Button.button>
              </div>
            </div>
            
    <!-- Sizes -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Sizes</h3>
              <div class="flex flex-wrap items-center gap-4">
                <Button.button size="xs">Extra Small</Button.button>
                <Button.button size="sm">Small</Button.button>
                <Button.button size="md">Medium</Button.button>
                <Button.button size="lg">Large</Button.button>
                <Button.button size="xl">Extra Large</Button.button>
              </div>
            </div>
            
    <!-- States -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">States</h3>
              <div class="flex flex-wrap gap-4">
                <Button.button>Normal</Button.button>
                <Button.button loading>Loading</Button.button>
                <Button.button disabled>Disabled</Button.button>
              </div>
            </div>
            
    <!-- With Icons -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">With Icons</h3>
              <div class="flex flex-wrap gap-4">
                <Button.button icon="hero-check">Save</Button.button>
                <Button.button trailing_icon="hero-arrow-right">Next</Button.button>
                <Button.button icon="hero-trash" color="error">Delete</Button.button>
              </div>
            </div>
            
    <!-- Block Button -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Block (Full Width)</h3>
              <div class="space-y-4">
                <Button.button block>Block Button</Button.button>
                <Button.button block variant="outline">Block Outline</Button.button>
              </div>
            </div>
            
    <!-- Square Buttons -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Square Buttons</h3>
              <div class="flex flex-wrap items-center gap-4">
                <Button.button square icon="hero-heart" size="xs" />
                <Button.button square icon="hero-star" size="sm" />
                <Button.button square icon="hero-plus" size="md" />
                <Button.button square icon="hero-x-mark" size="lg" color="error" />
              </div>
            </div>
            
    <!-- Code Example -->
            <div>
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Code Example</h3>
              <pre class="bg-gray-900 text-gray-100 p-4 rounded-lg overflow-x-auto text-sm"><code>&lt;.button color="primary" variant="solid" size="md"&gt;
                Click me
              &lt;/.button&gt;

              &lt;.button loading&gt;
                Submit
              &lt;/.button&gt;

              &lt;.button icon="hero-check" color="success"&gt;
                Save
              &lt;/.button&gt;

              &lt;.button block&gt;
                Full Width Button
              &lt;/.button&gt;</code></pre>
            </div>
          </section>
          
    <!-- Badge Component Section -->
          <section>
            <h2 class="text-3xl font-bold text-ui-text-default mb-2">Badge</h2>
            <p class="text-ui-text-dimmed mb-8">
              Badge component for displaying status, labels, and counts.
            </p>
            
    <!-- Variants -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Variants</h3>
              <div class="flex flex-wrap items-center gap-4">
                <Badge.badge variant="solid">Solid</Badge.badge>
                <Badge.badge variant="outline">Outline</Badge.badge>
                <Badge.badge variant="soft">Soft</Badge.badge>
                <Badge.badge variant="subtle">Subtle</Badge.badge>
              </div>
            </div>
            
    <!-- Colors -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Colors</h3>
              <div class="flex flex-wrap items-center gap-4">
                <Badge.badge color="gray">Gray</Badge.badge>
                <Badge.badge color="primary">Primary</Badge.badge>
                <Badge.badge color="success">Success</Badge.badge>
                <Badge.badge color="warning">Warning</Badge.badge>
                <Badge.badge color="error">Error</Badge.badge>
              </div>
            </div>
            
    <!-- Sizes -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Sizes</h3>
              <div class="flex flex-wrap items-center gap-4">
                <Badge.badge size="xs">Extra Small</Badge.badge>
                <Badge.badge size="sm">Small</Badge.badge>
                <Badge.badge size="md">Medium</Badge.badge>
                <Badge.badge size="lg">Large</Badge.badge>
              </div>
            </div>
            
    <!-- Use Cases -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Use Cases</h3>
              <div class="space-y-4">
                <!-- Status Indicators -->
                <div>
                  <h4 class="text-sm font-medium text-ui-text-muted mb-2">Status Indicators</h4>
                  <div class="flex flex-wrap gap-3">
                    <Badge.badge color="success" variant="soft">Active</Badge.badge>
                    <Badge.badge color="warning" variant="soft">Pending</Badge.badge>
                    <Badge.badge color="error" variant="soft">Inactive</Badge.badge>
                    <Badge.badge color="gray" variant="soft">Draft</Badge.badge>
                  </div>
                </div>
                
    <!-- Count Badges -->
                <div>
                  <h4 class="text-sm font-medium text-ui-text-muted mb-2">Count Badges</h4>
                  <div class="flex flex-wrap gap-3">
                    <Badge.badge color="primary" size="xs">3</Badge.badge>
                    <Badge.badge color="primary" size="sm">10</Badge.badge>
                    <Badge.badge color="primary" size="md">99+</Badge.badge>
                  </div>
                </div>
                
    <!-- Labels and Tags -->
                <div>
                  <h4 class="text-sm font-medium text-ui-text-muted mb-2">Labels and Tags</h4>
                  <div class="flex flex-wrap gap-3">
                    <Badge.badge variant="outline" color="primary">Feature</Badge.badge>
                    <Badge.badge variant="outline" color="success">Bug Fix</Badge.badge>
                    <Badge.badge variant="outline" color="warning">Enhancement</Badge.badge>
                    <Badge.badge variant="outline" color="error">Breaking</Badge.badge>
                  </div>
                </div>
                
    <!-- Subtle Variants -->
                <div>
                  <h4 class="text-sm font-medium text-ui-text-muted mb-2">Subtle Variants</h4>
                  <div class="flex flex-wrap gap-3">
                    <Badge.badge variant="subtle" color="primary">New</Badge.badge>
                    <Badge.badge variant="subtle" color="success">Updated</Badge.badge>
                    <Badge.badge variant="subtle" color="warning">Beta</Badge.badge>
                  </div>
                </div>
              </div>
            </div>
            
    <!-- Combined with Other Elements -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Combined Examples</h3>
              <div class="space-y-4">
                <div class="flex items-center gap-3">
                  <span class="text-ui-text-default">Notifications</span>
                  <Badge.badge color="error" size="xs">5</Badge.badge>
                </div>
                <div class="flex items-center gap-3">
                  <span class="text-ui-text-default">Messages</span>
                  <Badge.badge color="primary" size="sm">12</Badge.badge>
                </div>
                <div class="flex items-center gap-3">
                  <span class="text-ui-text-default">Tasks</span>
                  <Badge.badge color="success" size="md" variant="soft">Completed</Badge.badge>
                </div>
              </div>
            </div>
            
    <!-- Code Example -->
            <div>
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Code Example</h3>
              <pre class="bg-gray-900 text-gray-100 p-4 rounded-lg overflow-x-auto text-sm"><code>&lt;.badge color="primary" variant="solid"&gt;
                New
              &lt;/.badge&gt;

              &lt;.badge color="success" variant="soft" size="sm"&gt;
                Active
              &lt;/.badge&gt;

              &lt;.badge color="warning" variant="outline"&gt;
                Pending
              &lt;/.badge&gt;

              &lt;.badge color="error" size="xs"&gt;
                3
              &lt;/.badge&gt;</code></pre>
            </div>
          </section>
          
    <!-- Avatar Component Section -->
          <section>
            <h2 class="text-3xl font-bold text-ui-text-default mb-2">Avatar</h2>
            <p class="text-ui-text-dimmed mb-8">
              Avatar component for displaying user profile images with fallback support.
            </p>
            
    <!-- Basic Avatars with Image -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">With Image</h3>
              <div class="flex flex-wrap items-center gap-4">
                <Avatar.avatar src="https://github.com/benjamincanac.png" alt="Benjamin Canac" />
                <Avatar.avatar src="https://github.com/atinux.png" alt="Sebastien Chopin" size="lg" />
                <Avatar.avatar src="https://github.com/pi0.png" alt="Pooya Parsa" size="xl" />
              </div>
            </div>
            
    <!-- Initials Fallback -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">
                Initials Fallback (No Image)
              </h3>
              <div class="flex flex-wrap items-center gap-4">
                <Avatar.avatar alt="John Doe" />
                <Avatar.avatar alt="Jane Smith" size="lg" />
                <Avatar.avatar alt="Alex Johnson" size="xl" />
              </div>
            </div>
            
    <!-- Text Fallback -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Custom Text</h3>
              <div class="flex flex-wrap items-center gap-4">
                <Avatar.avatar text="AB" />
                <Avatar.avatar text="+1" size="lg" />
                <Avatar.avatar text="99" size="xl" />
              </div>
            </div>
            
    <!-- Icon Fallback -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Icon Fallback</h3>
              <div class="flex flex-wrap items-center gap-4">
                <Avatar.avatar icon="hero-user" />
                <Avatar.avatar icon="hero-user-circle" size="lg" />
                <Avatar.avatar icon="hero-user-group" size="xl" />
              </div>
            </div>
            
    <!-- Size Variants -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Size Variants</h3>
              <div class="flex flex-wrap items-center gap-4">
                <Avatar.avatar alt="3XS" size="3xs" />
                <Avatar.avatar alt="2XS" size="2xs" />
                <Avatar.avatar alt="XS" size="xs" />
                <Avatar.avatar alt="SM" size="sm" />
                <Avatar.avatar alt="MD" size="md" />
                <Avatar.avatar alt="LG" size="lg" />
                <Avatar.avatar alt="XL" size="xl" />
                <Avatar.avatar alt="2XL" size="2xl" />
                <Avatar.avatar alt="3XL" size="3xl" />
              </div>
            </div>
            
    <!-- With Status Chip -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">
                With Status Indicator
              </h3>
              <div class="space-y-6">
                <!-- Online Status -->
                <div>
                  <h4 class="text-sm font-medium text-ui-text-muted mb-3">Online Status</h4>
                  <div class="flex flex-wrap items-center gap-6">
                    <Avatar.avatar
                      src="https://github.com/benjamincanac.png"
                      alt="Online User"
                      chip={%{color: "success", position: "bottom-right"}}
                    />
                    <Avatar.avatar
                      alt="Online User"
                      size="lg"
                      chip={%{color: "success", position: "bottom-right"}}
                    />
                    <Avatar.avatar
                      alt="Online User"
                      size="xl"
                      chip={%{color: "success", position: "bottom-right"}}
                    />
                  </div>
                </div>
                
    <!-- Away Status -->
                <div>
                  <h4 class="text-sm font-medium text-ui-text-muted mb-3">Away Status</h4>
                  <div class="flex flex-wrap items-center gap-6">
                    <Avatar.avatar
                      src="https://github.com/atinux.png"
                      alt="Away User"
                      chip={%{color: "warning", position: "bottom-right"}}
                    />
                    <Avatar.avatar
                      alt="Away User"
                      size="lg"
                      chip={%{color: "warning", position: "bottom-right"}}
                    />
                  </div>
                </div>
                
    <!-- Offline Status -->
                <div>
                  <h4 class="text-sm font-medium text-ui-text-muted mb-3">Offline Status</h4>
                  <div class="flex flex-wrap items-center gap-6">
                    <Avatar.avatar
                      src="https://github.com/pi0.png"
                      alt="Offline User"
                      chip={%{color: "error", position: "bottom-right"}}
                    />
                    <Avatar.avatar
                      alt="Offline User"
                      size="lg"
                      chip={%{color: "gray", position: "bottom-right"}}
                    />
                  </div>
                </div>
                
    <!-- Different Chip Positions -->
                <div>
                  <h4 class="text-sm font-medium text-ui-text-muted mb-3">Chip Positions</h4>
                  <div class="flex flex-wrap items-center gap-6">
                    <Avatar.avatar
                      alt="User"
                      size="xl"
                      chip={%{color: "success", position: "top-right"}}
                    />
                    <Avatar.avatar
                      alt="User"
                      size="xl"
                      chip={%{color: "success", position: "top-left"}}
                    />
                    <Avatar.avatar
                      alt="User"
                      size="xl"
                      chip={%{color: "success", position: "bottom-right"}}
                    />
                    <Avatar.avatar
                      alt="User"
                      size="xl"
                      chip={%{color: "success", position: "bottom-left"}}
                    />
                  </div>
                </div>
              </div>
            </div>
            
    <!-- Use Cases -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Use Cases</h3>
              <div class="space-y-6">
                <!-- User Profile -->
                <div>
                  <h4 class="text-sm font-medium text-ui-text-muted mb-3">User Profile</h4>
                  <div class="flex items-center gap-3">
                    <Avatar.avatar
                      src="https://github.com/benjamincanac.png"
                      alt="Benjamin Canac"
                      size="lg"
                      chip={%{color: "success", position: "bottom-right"}}
                    />
                    <div>
                      <p class="font-medium text-ui-text-default">Benjamin Canac</p>
                      <p class="text-sm text-ui-text-muted">benjamin@nuxtlabs.com</p>
                    </div>
                  </div>
                </div>
                
    <!-- Avatar Group -->
                <div>
                  <h4 class="text-sm font-medium text-ui-text-muted mb-3">Avatar Group</h4>
                  <div class="flex -space-x-2">
                    <Avatar.avatar
                      src="https://github.com/benjamincanac.png"
                      alt="User 1"
                      class="ring-2 ring-white dark:ring-gray-900"
                    />
                    <Avatar.avatar
                      src="https://github.com/atinux.png"
                      alt="User 2"
                      class="ring-2 ring-white dark:ring-gray-900"
                    />
                    <Avatar.avatar
                      src="https://github.com/pi0.png"
                      alt="User 3"
                      class="ring-2 ring-white dark:ring-gray-900"
                    />
                    <Avatar.avatar
                      text="+5"
                      class="ring-2 ring-white dark:ring-gray-900"
                    />
                  </div>
                </div>
                
    <!-- Comment Thread -->
                <div>
                  <h4 class="text-sm font-medium text-ui-text-muted mb-3">Comment Thread</h4>
                  <div class="space-y-3">
                    <div class="flex items-start gap-3">
                      <Avatar.avatar alt="John Doe" size="sm" />
                      <div class="flex-1">
                        <p class="text-sm font-medium text-ui-text-default">John Doe</p>
                        <p class="text-sm text-ui-text-dimmed">Great work on this feature!</p>
                      </div>
                    </div>
                    <div class="flex items-start gap-3">
                      <Avatar.avatar alt="Jane Smith" size="sm" />
                      <div class="flex-1">
                        <p class="text-sm font-medium text-ui-text-default">Jane Smith</p>
                        <p class="text-sm text-ui-text-dimmed">Thanks! Ready for review.</p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            
    <!-- Code Example -->
            <div>
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Code Example</h3>
              <pre class="bg-gray-900 text-gray-100 p-4 rounded-lg overflow-x-auto text-sm"><code>&lt;!-- Avatar with image --&gt;
              &lt;.avatar src="/user.jpg" alt="John Doe" /&gt;

              &lt;!-- Avatar with initials fallback --&gt;
              &lt;.avatar alt="John Doe" size="lg" /&gt;

              &lt;!-- Avatar with text --&gt;
              &lt;.avatar text="JD" /&gt;

              &lt;!-- Avatar with icon --&gt;
              &lt;.avatar icon="hero-user" /&gt;

              &lt;!-- Size variants --&gt;
              &lt;.avatar alt="User" size="xs" /&gt;
              &lt;.avatar alt="User" size="md" /&gt;
              &lt;.avatar alt="User" size="xl" /&gt;</code></pre>
            </div>
          </section>
          
    <!-- Card Component Section -->
          <section>
            <h2 class="text-3xl font-bold text-ui-text-default mb-2">Card</h2>
            <p class="text-ui-text-dimmed mb-8">
              Card component for displaying content with optional header and footer sections.
            </p>
            
    <!-- Basic Card -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Basic Card</h3>
              <div class="max-w-md">
                <Card.card>
                  <p class="text-ui-text-default">
                    This is a simple card with just body content. No header or footer.
                  </p>
                </Card.card>
              </div>
            </div>
            
    <!-- Card with Header -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Card with Header</h3>
              <div class="max-w-md">
                <Card.card>
                  <:header>
                    <h3 class="text-lg font-semibold text-ui-text-default">Card Title</h3>
                  </:header>
                  <p class="text-ui-text-default">
                    This card has a header section with a title.
                  </p>
                </Card.card>
              </div>
            </div>
            
    <!-- Card with Footer -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Card with Footer</h3>
              <div class="max-w-md">
                <Card.card>
                  <p class="text-ui-text-default mb-4">
                    This card has a footer section with actions.
                  </p>
                  <:footer>
                    <div class="flex justify-end gap-2">
                      <Button.button variant="outline" size="sm">Cancel</Button.button>
                      <Button.button size="sm">Save</Button.button>
                    </div>
                  </:footer>
                </Card.card>
              </div>
            </div>
            
    <!-- Full Card -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">
                Full Card (Header + Body + Footer)
              </h3>
              <div class="max-w-md">
                <Card.card>
                  <:header>
                    <div class="flex items-center justify-between">
                      <h3 class="text-lg font-semibold text-ui-text-default">User Profile</h3>
                      <Badge.badge color="success" size="sm">Active</Badge.badge>
                    </div>
                  </:header>
                  <div class="space-y-3">
                    <div class="flex items-center gap-3">
                      <Avatar.avatar alt="John Doe" size="lg" />
                      <div>
                        <p class="font-medium text-ui-text-default">John Doe</p>
                        <p class="text-sm text-ui-text-muted">john@example.com</p>
                      </div>
                    </div>
                    <p class="text-sm text-ui-text-dimmed">
                      Senior Software Engineer with 10+ years of experience.
                    </p>
                  </div>
                  <:footer>
                    <div class="flex justify-between">
                      <Button.button variant="outline" size="sm">View Profile</Button.button>
                      <Button.button size="sm">Send Message</Button.button>
                    </div>
                  </:footer>
                </Card.card>
              </div>
            </div>
            
    <!-- Variants -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Variants</h3>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- Outline (default) -->
                <Card.card variant="outline">
                  <:header>
                    <h4 class="font-semibold text-ui-text-default">Outline (Default)</h4>
                  </:header>
                  <p class="text-ui-text-default">
                    Border with dividers between sections.
                  </p>
                </Card.card>
                
    <!-- Solid -->
                <Card.card variant="solid">
                  <:header>
                    <h4 class="font-semibold">Solid</h4>
                  </:header>
                  <p>Inverted background with text.</p>
                </Card.card>
                
    <!-- Soft -->
                <Card.card variant="soft">
                  <:header>
                    <h4 class="font-semibold text-ui-text-default">Soft</h4>
                  </:header>
                  <p class="text-ui-text-default">
                    Elevated background with dividers.
                  </p>
                </Card.card>
                
    <!-- Subtle -->
                <Card.card variant="subtle">
                  <:header>
                    <h4 class="font-semibold text-ui-text-default">Subtle</h4>
                  </:header>
                  <p class="text-ui-text-default">
                    Elevated background with ring and dividers.
                  </p>
                </Card.card>
              </div>
            </div>
            
    <!-- Padding Variants -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Padding Variants</h3>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <Card.card padding="sm">
                  <:header>
                    <h4 class="font-semibold text-ui-text-default">Small Padding</h4>
                  </:header>
                  <p class="text-ui-text-default">Compact card with small padding.</p>
                </Card.card>

                <Card.card padding="md">
                  <:header>
                    <h4 class="font-semibold text-ui-text-default">Medium Padding (Default)</h4>
                  </:header>
                  <p class="text-ui-text-default">Standard card with medium padding.</p>
                </Card.card>

                <Card.card padding="lg">
                  <:header>
                    <h4 class="font-semibold text-ui-text-default">Large Padding</h4>
                  </:header>
                  <p class="text-ui-text-default">Spacious card with large padding.</p>
                </Card.card>

                <Card.card padding="none">
                  <img src="https://picsum.photos/400/200" alt="Full bleed image" class="w-full" />
                  <div class="p-4">
                    <h4 class="font-semibold text-ui-text-default mb-2">No Padding</h4>
                    <p class="text-ui-text-default">
                      Useful for full-bleed images with custom padding.
                    </p>
                  </div>
                </Card.card>
              </div>
            </div>
            
    <!-- Use Cases -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Use Cases</h3>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- Dashboard Card -->
                <Card.card>
                  <:header>
                    <div class="flex items-center justify-between">
                      <h4 class="font-semibold text-ui-text-default">Total Revenue</h4>
                      <Badge.badge color="success" variant="soft" size="sm">+12%</Badge.badge>
                    </div>
                  </:header>
                  <div>
                    <p class="text-3xl font-bold text-ui-text-default">$45,231</p>
                    <p class="text-sm text-ui-text-muted mt-1">vs. $40,391 last month</p>
                  </div>
                  <:footer>
                    <Button.button variant="link" size="sm">View Details →</Button.button>
                  </:footer>
                </Card.card>
                
    <!-- Article Card -->
                <Card.card>
                  <:header>
                    <div class="flex items-center gap-2">
                      <Badge.badge color="primary" size="xs">Featured</Badge.badge>
                      <Badge.badge color="gray" size="xs" variant="outline">Tutorial</Badge.badge>
                    </div>
                  </:header>
                  <div>
                    <h4 class="text-lg font-semibold text-ui-text-default mb-2">
                      Getting Started with Phoenix LiveView
                    </h4>
                    <p class="text-sm text-ui-text-dimmed">
                      Learn how to build real-time applications with Phoenix LiveView.
                    </p>
                  </div>
                  <:footer>
                    <div class="flex items-center justify-between text-sm text-ui-text-muted">
                      <span>5 min read</span>
                      <span>Jan 15, 2025</span>
                    </div>
                  </:footer>
                </Card.card>
                
    <!-- Form Card -->
                <Card.card>
                  <:header>
                    <h4 class="font-semibold text-ui-text-default">Contact Form</h4>
                  </:header>
                  <form class="space-y-4">
                    <div>
                      <label class="block text-sm font-medium text-ui-text-default mb-1">Name</label>
                      <input
                        type="text"
                        class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
                        placeholder="Your name"
                      />
                    </div>
                    <div>
                      <label class="block text-sm font-medium text-ui-text-default mb-1">Email</label>
                      <input
                        type="email"
                        class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
                        placeholder="you@example.com"
                      />
                    </div>
                  </form>
                  <:footer>
                    <div class="flex gap-2">
                      <Button.button variant="outline" size="sm" block>Cancel</Button.button>
                      <Button.button size="sm" block>Submit</Button.button>
                    </div>
                  </:footer>
                </Card.card>
                
    <!-- Notification Card -->
                <Card.card variant="soft">
                  <:header>
                    <div class="flex items-start gap-3">
                      <Avatar.avatar alt="System" icon="hero-bell" size="sm" />
                      <div>
                        <h4 class="font-semibold text-ui-text-default">New Update Available</h4>
                        <p class="text-xs text-ui-text-muted">2 hours ago</p>
                      </div>
                    </div>
                  </:header>
                  <p class="text-sm text-ui-text-default">
                    Version 2.0 is now available with new features and improvements.
                  </p>
                  <:footer>
                    <div class="flex gap-2">
                      <Button.button variant="outline" size="sm">Later</Button.button>
                      <Button.button size="sm">Update Now</Button.button>
                    </div>
                  </:footer>
                </Card.card>
              </div>
            </div>
            
    <!-- Code Example -->
            <div>
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Code Example</h3>
              <pre class="bg-gray-900 text-gray-100 p-4 rounded-lg overflow-x-auto text-sm"><code>&lt;!-- Simple card --&gt;
              &lt;.card&gt;
                &lt;p&gt;Card content&lt;/p&gt;
              &lt;/.card&gt;

              &lt;!-- Card with header --&gt;
              &lt;.card&gt;
                &lt;:header&gt;
                  &lt;h3&gt;Card Title&lt;/h3&gt;
                &lt;/:header&gt;
                &lt;p&gt;Main content&lt;/p&gt;
              &lt;/.card&gt;

              &lt;!-- Full card --&gt;
              &lt;.card variant="soft" padding="lg"&gt;
                &lt;:header&gt;
                  &lt;h3&gt;Title&lt;/h3&gt;
                &lt;/:header&gt;
                &lt;p&gt;Body content&lt;/p&gt;
                &lt;:footer&gt;
                  &lt;button&gt;Action&lt;/button&gt;
                &lt;/:footer&gt;
              &lt;/.card&gt;

              &lt;!-- Card with no padding (full-bleed image) --&gt;
              &lt;.card padding="none"&gt;
                &lt;img src="/image.jpg" alt="Hero" /&gt;
                &lt;div class="p-4"&gt;
                  &lt;p&gt;Custom padding&lt;/p&gt;
                &lt;/div&gt;
              &lt;/.card&gt;</code></pre>
            </div>
          </section>
          
    <!-- Alert Component Section -->
          <section>
            <h2 class="text-3xl font-bold text-ui-text-default mb-2">Alert</h2>
            <p class="text-ui-text-dimmed mb-8">
              Alert component for displaying contextual feedback messages with accessibility support.
            </p>
            
    <!-- Basic Alerts by Severity -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Alert Severity Types</h3>
              <div class="space-y-4">
                <Alert.alert color="info">
                  <:title>Information</:title>
                  This is an informational message.
                </Alert.alert>
                <Alert.alert color="success">
                  <:title>Success!</:title>
                  Your changes have been saved successfully.
                </Alert.alert>
                <Alert.alert color="warning">
                  <:title>Warning</:title>
                  This action cannot be undone. Please proceed with caution.
                </Alert.alert>
                <Alert.alert color="error">
                  <:title>Error</:title>
                  Failed to process your request. Please try again.
                </Alert.alert>
              </div>
            </div>
            
    <!-- Variants -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Variants</h3>
              <div class="space-y-4">
                <Alert.alert color="info" variant="soft">
                  Soft variant with light background (default)
                </Alert.alert>
                <Alert.alert color="info" variant="solid">
                  Solid variant with white text
                </Alert.alert>
                <Alert.alert color="info" variant="outline">
                  Outline variant with colored border
                </Alert.alert>
                <Alert.alert color="info" variant="subtle">
                  Subtle variant with background and border
                </Alert.alert>
              </div>
            </div>
            
    <!-- With Actions -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">With Actions</h3>
              <div class="space-y-4">
                <!-- Vertical orientation (default) -->
                <Alert.alert color="warning">
                  <:title>Update Available</:title>
                  A new version of the application is available.
                  <:actions>
                    <Button.button size="xs" variant="soft" color="warning">
                      View changes
                    </Button.button>
                    <Button.button size="xs" color="warning">Update now</Button.button>
                  </:actions>
                </Alert.alert>
                
    <!-- Horizontal orientation -->
                <Alert.alert color="info" orientation="horizontal">
                  <:title>New feature</:title>
                  Check out our latest updates!
                  <:actions>
                    <Button.button size="xs" variant="link">Learn more →</Button.button>
                  </:actions>
                </Alert.alert>
              </div>
            </div>
            
    <!-- Dismissible Alerts -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Dismissible Alerts</h3>
              <div class="space-y-4">
                <Alert.alert id="dismissible-1" color="success" close>
                  <:title>Success!</:title>
                  Your settings have been saved.
                </Alert.alert>
                <Alert.alert id="dismissible-2" color="info" close>
                  Click the X button to dismiss this alert.
                </Alert.alert>
                <Alert.alert id="dismissible-3" color="warning" orientation="horizontal" close>
                  <:title>Action required</:title>
                  Please verify your email address.
                </Alert.alert>
              </div>
            </div>
            
    <!-- Custom Icons -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Custom Icons</h3>
              <div class="space-y-4">
                <Alert.alert color="primary" icon="hero-rocket-launch">
                  <:title>New Feature!</:title>
                  We've launched an exciting new feature for you to explore.
                </Alert.alert>
                <Alert.alert color="secondary" icon="hero-bell">
                  You have 3 unread notifications.
                </Alert.alert>
              </div>
            </div>
            
    <!-- Description Only (No Title) -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Description Only</h3>
              <div class="space-y-4">
                <Alert.alert color="info">
                  Simple informational alert without a title.
                </Alert.alert>
                <Alert.alert color="success" close>
                  Operation completed successfully.
                </Alert.alert>
              </div>
            </div>
            
    <!-- Use Cases -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Use Cases</h3>
              <div class="space-y-4">
                <!-- Form validation error -->
                <Alert.alert color="error" variant="soft">
                  <:title>Validation Error</:title>
                  Please fix the following errors:
                  <ul class="list-disc list-inside mt-2 space-y-1">
                    <li>Email address is required</li>
                    <li>Password must be at least 8 characters</li>
                  </ul>
                </Alert.alert>
                
    <!-- Low storage warning with actions -->
                <Alert.alert color="warning" close>
                  <:title>Low Disk Space</:title>
                  You have less than 10% storage remaining. Free up space to continue.
                  <:actions>
                    <Button.button size="xs" variant="outline" color="warning">
                      Manage storage
                    </Button.button>
                  </:actions>
                </Alert.alert>
                
    <!-- Success confirmation -->
                <Alert.alert color="success" variant="subtle" close>
                  <:title>Payment Successful</:title>
                  Your payment of $49.99 has been processed.
                </Alert.alert>
                
    <!-- Informational banner -->
                <Alert.alert color="info" variant="outline" orientation="horizontal">
                  🎉 New year sale! Get 20% off all premium plans.
                  <:actions>
                    <Button.button size="xs" variant="link">Shop now →</Button.button>
                  </:actions>
                </Alert.alert>
              </div>
            </div>
            
    <!-- Color Combinations -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">All Color Options</h3>
              <div class="space-y-4">
                <Alert.alert color="primary">Primary color alert</Alert.alert>
                <Alert.alert color="secondary">Secondary color alert</Alert.alert>
                <Alert.alert color="neutral">Neutral color alert</Alert.alert>
              </div>
            </div>
            
    <!-- Accessibility Notes -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">
                Accessibility Features
              </h3>
              <div class="space-y-4">
                <div class="p-4 bg-gray-50 dark:bg-gray-900 rounded-lg">
                  <p class="text-sm text-ui-text-default mb-3">
                    <strong>Alert component accessibility:</strong>
                  </p>
                  <ul class="list-disc list-inside space-y-2 text-sm text-ui-text-dimmed">
                    <li>
                      All alerts include
                      <code class="px-1 py-0.5 bg-gray-200 dark:bg-gray-800 rounded">
                        role="alert"
                      </code>
                      for screen readers
                    </li>
                    <li>
                      Info/Success alerts use
                      <code class="px-1 py-0.5 bg-gray-200 dark:bg-gray-800 rounded">
                        aria-live="polite"
                      </code>
                      (non-urgent)
                    </li>
                    <li>
                      Warning/Error alerts use
                      <code class="px-1 py-0.5 bg-gray-200 dark:bg-gray-800 rounded">
                        aria-live="assertive"
                      </code>
                      (urgent)
                    </li>
                    <li>
                      Icons are decorative (<code class="px-1 py-0.5 bg-gray-200 dark:bg-gray-800 rounded">
                        aria-hidden="true"
                      </code> ) - color not sole indicator
                    </li>
                    <li>
                      Close button includes
                      <code class="px-1 py-0.5 bg-gray-200 dark:bg-gray-800 rounded">
                        aria-label="Close alert"
                      </code>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
            
    <!-- Code Example -->
            <div>
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Code Example</h3>
              <pre class="bg-gray-900 text-gray-100 p-4 rounded-lg overflow-x-auto text-sm"><code>&lt;!-- Simple alert --&gt;
              &lt;.alert color="info" description="Informational message" /&gt;

              &lt;!-- Alert with title and description --&gt;
              &lt;.alert color="success" title="Success!" &gt;
                Your changes have been saved successfully.
              &lt;/.alert&gt;

              &lt;!-- Alert with actions --&gt;
              &lt;.alert color="warning" title="Warning"&gt;
                &lt;:description&gt;
                  This action cannot be undone.
                &lt;/:description&gt;
                &lt;:actions&gt;
                  &lt;.button size="xs"&gt;Confirm&lt;/.button&gt;
                  &lt;.button size="xs" variant="outline"&gt;Cancel&lt;/.button&gt;
                &lt;/:actions&gt;
              &lt;/.alert&gt;

              &lt;!-- Dismissible alert --&gt;
              &lt;.alert
                color="error"
                title="Error occurred"
                description="Failed to process your request."
                close
              /&gt;

              &lt;!-- Custom icon --&gt;
              &lt;.alert
                color="info"
                icon="hero-rocket-launch"
                title="New feature available"
                description="Check out our latest updates!"
              /&gt;

              &lt;!-- Horizontal layout with actions --&gt;
              &lt;.alert
                color="info"
                orientation="horizontal"
                description="Banner message"
              &gt;
                &lt;:actions&gt;
                  &lt;.button size="xs" variant="link"&gt;Learn more →&lt;/.button&gt;
                &lt;/:actions&gt;
              &lt;/.alert&gt;</code></pre>
            </div>
          </section>
          
    <!-- Divider Component Section -->
          <section>
            <h2 class="text-3xl font-bold text-ui-text-default mb-2">Divider</h2>
            <p class="text-ui-text-dimmed mb-8">
              Divider component for visually separating content horizontally or vertically.
            </p>
            
    <!-- Basic Horizontal Divider -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">
                Basic Horizontal Divider
              </h3>
              <div class="space-y-6">
                <div>
                  <p class="text-ui-text-default mb-2">Section 1</p>
                  <Divider.divider />
                  <p class="text-ui-text-default mt-2">Section 2</p>
                </div>
              </div>
            </div>
            
    <!-- Divider with Label -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Divider with Label</h3>
              <div class="space-y-6">
                <Divider.divider label="OR" />
                <Divider.divider label="Section 1" />
                <Divider.divider label="Personal Information" />
              </div>
            </div>
            
    <!-- Divider with Icon -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Divider with Icon</h3>
              <div class="space-y-6">
                <Divider.divider icon="hero-star" />
                <Divider.divider icon="hero-ellipsis-horizontal" />
              </div>
            </div>
            
    <!-- Size Variants -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Size Variants</h3>
              <div class="space-y-4">
                <div>
                  <p class="text-sm text-ui-text-muted mb-2">Extra Small (xs - 1px)</p>
                  <Divider.divider size="xs" />
                </div>
                <div>
                  <p class="text-sm text-ui-text-muted mb-2">Small (sm - 2px)</p>
                  <Divider.divider size="sm" />
                </div>
                <div>
                  <p class="text-sm text-ui-text-muted mb-2">Medium (md - 3px)</p>
                  <Divider.divider size="md" />
                </div>
                <div>
                  <p class="text-sm text-ui-text-muted mb-2">Large (lg - 4px)</p>
                  <Divider.divider size="lg" />
                </div>
                <div>
                  <p class="text-sm text-ui-text-muted mb-2">Extra Large (xl - 5px)</p>
                  <Divider.divider size="xl" />
                </div>
              </div>
            </div>
            
    <!-- Type Variants -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Border Type Variants</h3>
              <div class="space-y-4">
                <div>
                  <p class="text-sm text-ui-text-muted mb-2">Solid (default)</p>
                  <Divider.divider type="solid" />
                </div>
                <div>
                  <p class="text-sm text-ui-text-muted mb-2">Dashed</p>
                  <Divider.divider type="dashed" />
                </div>
                <div>
                  <p class="text-sm text-ui-text-muted mb-2">Dotted</p>
                  <Divider.divider type="dotted" />
                </div>
              </div>
            </div>
            
    <!-- Color Variants -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Color Variants</h3>
              <div class="space-y-4">
                <div>
                  <p class="text-sm text-ui-text-muted mb-2">Neutral (default)</p>
                  <Divider.divider color="neutral" />
                </div>
                <div>
                  <p class="text-sm text-ui-text-muted mb-2">Primary</p>
                  <Divider.divider color="primary" />
                </div>
                <div>
                  <p class="text-sm text-ui-text-muted mb-2">Success</p>
                  <Divider.divider color="success" />
                </div>
                <div>
                  <p class="text-sm text-ui-text-muted mb-2">Info</p>
                  <Divider.divider color="info" />
                </div>
                <div>
                  <p class="text-sm text-ui-text-muted mb-2">Warning</p>
                  <Divider.divider color="warning" />
                </div>
                <div>
                  <p class="text-sm text-ui-text-muted mb-2">Error</p>
                  <Divider.divider color="error" />
                </div>
              </div>
            </div>
            
    <!-- Vertical Divider -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Vertical Divider</h3>
              <div class="flex items-center h-32 gap-4">
                <p class="text-ui-text-default">Left</p>
                <Divider.divider orientation="vertical" class="h-full" />
                <p class="text-ui-text-default">Middle</p>
                <Divider.divider orientation="vertical" class="h-full" />
                <p class="text-ui-text-default">Right</p>
              </div>
            </div>
            
    <!-- Vertical with Label and Icon -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">
                Vertical with Label and Icon
              </h3>
              <div class="flex items-center h-48 gap-6">
                <div class="flex-1 text-center">
                  <p class="text-ui-text-default">Section 1</p>
                </div>
                <Divider.divider orientation="vertical" label="OR" class="h-full" />
                <div class="flex-1 text-center">
                  <p class="text-ui-text-default">Section 2</p>
                </div>
                <Divider.divider orientation="vertical" icon="hero-ellipsis-vertical" class="h-full" />
                <div class="flex-1 text-center">
                  <p class="text-ui-text-default">Section 3</p>
                </div>
              </div>
            </div>
            
    <!-- Use Cases -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Use Cases</h3>
              <div class="space-y-8">
                <!-- Form Sections -->
                <div>
                  <h4 class="text-sm font-medium text-ui-text-muted mb-4">Form Sections</h4>
                  <div class="max-w-md space-y-4">
                    <Divider.divider label="Personal Information" color="primary" />
                    <div class="space-y-3">
                      <div>
                        <label class="block text-sm font-medium text-ui-text-default mb-1">
                          Name
                        </label>
                        <input
                          type="text"
                          class="w-full px-3 py-2 border border-gray-300 rounded-lg"
                          placeholder="John Doe"
                        />
                      </div>
                      <div>
                        <label class="block text-sm font-medium text-ui-text-default mb-1">
                          Email
                        </label>
                        <input
                          type="email"
                          class="w-full px-3 py-2 border border-gray-300 rounded-lg"
                          placeholder="john@example.com"
                        />
                      </div>
                    </div>
                    <Divider.divider label="Address" color="primary" />
                    <div class="space-y-3">
                      <div>
                        <label class="block text-sm font-medium text-ui-text-default mb-1">
                          Street
                        </label>
                        <input
                          type="text"
                          class="w-full px-3 py-2 border border-gray-300 rounded-lg"
                          placeholder="123 Main St"
                        />
                      </div>
                      <div>
                        <label class="block text-sm font-medium text-ui-text-default mb-1">
                          City
                        </label>
                        <input
                          type="text"
                          class="w-full px-3 py-2 border border-gray-300 rounded-lg"
                          placeholder="New York"
                        />
                      </div>
                    </div>
                  </div>
                </div>
                
    <!-- Login Form with OR Divider -->
                <div>
                  <h4 class="text-sm font-medium text-ui-text-muted mb-4">Login Options</h4>
                  <div class="max-w-md space-y-4">
                    <Button.button block variant="outline">Sign in with Google</Button.button>
                    <Button.button block variant="outline">Sign in with GitHub</Button.button>
                    <Divider.divider label="OR" />
                    <div class="space-y-3">
                      <input
                        type="email"
                        class="w-full px-3 py-2 border border-gray-300 rounded-lg"
                        placeholder="Email address"
                      />
                      <input
                        type="password"
                        class="w-full px-3 py-2 border border-gray-300 rounded-lg"
                        placeholder="Password"
                      />
                      <Button.button block>Sign In</Button.button>
                    </div>
                  </div>
                </div>
                
    <!-- List Separation -->
                <div>
                  <h4 class="text-sm font-medium text-ui-text-muted mb-4">List Separation</h4>
                  <div class="max-w-md">
                    <div class="p-4 hover:bg-gray-50 dark:hover:bg-gray-900">
                      <p class="font-medium text-ui-text-default">Item 1</p>
                      <p class="text-sm text-ui-text-dimmed">Description for item 1</p>
                    </div>
                    <Divider.divider />
                    <div class="p-4 hover:bg-gray-50 dark:hover:bg-gray-900">
                      <p class="font-medium text-ui-text-default">Item 2</p>
                      <p class="text-sm text-ui-text-dimmed">Description for item 2</p>
                    </div>
                    <Divider.divider />
                    <div class="p-4 hover:bg-gray-50 dark:hover:bg-gray-900">
                      <p class="font-medium text-ui-text-default">Item 3</p>
                      <p class="text-sm text-ui-text-dimmed">Description for item 3</p>
                    </div>
                  </div>
                </div>
                
    <!-- Card Sections -->
                <div>
                  <h4 class="text-sm font-medium text-ui-text-muted mb-4">Card Sections</h4>
                  <div class="max-w-md">
                    <Card.card padding="none">
                      <div class="p-6">
                        <h3 class="text-lg font-semibold text-ui-text-default mb-2">Article Title</h3>
                        <p class="text-sm text-ui-text-dimmed">
                          Article excerpt or introduction goes here...
                        </p>
                      </div>
                      <Divider.divider />
                      <div class="p-6">
                        <h4 class="font-medium text-ui-text-default mb-2">Section 1</h4>
                        <p class="text-sm text-ui-text-default">Content for section 1</p>
                      </div>
                      <Divider.divider />
                      <div class="p-6">
                        <h4 class="font-medium text-ui-text-default mb-2">Section 2</h4>
                        <p class="text-sm text-ui-text-default">Content for section 2</p>
                      </div>
                    </Card.card>
                  </div>
                </div>
              </div>
            </div>
            
    <!-- Combined Styles -->
            <div class="mb-12">
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Combined Styles</h3>
              <div class="space-y-6">
                <Divider.divider label="Primary Section" color="primary" size="lg" />
                <Divider.divider label="Dashed Warning" color="warning" type="dashed" size="md" />
                <Divider.divider icon="hero-star" color="success" size="sm" />
              </div>
            </div>
            
    <!-- Code Example -->
            <div>
              <h3 class="text-xl font-semibold text-ui-text-default mb-4">Code Example</h3>
              <pre class="bg-gray-900 text-gray-100 p-4 rounded-lg overflow-x-auto text-sm"><code>&lt;!-- Simple horizontal divider --&gt;
              &lt;.divider /&gt;

              &lt;!-- Divider with label --&gt;
              &lt;.divider label="OR" /&gt;

              &lt;!-- Divider with icon --&gt;
              &lt;.divider icon="hero-star" /&gt;

              &lt;!-- Styled divider --&gt;
              &lt;.divider
                label="Section"
                color="primary"
                size="lg"
                type="dashed"
              /&gt;

              &lt;!-- Vertical divider (needs container with height) --&gt;
              &lt;div class="flex h-32"&gt;
                &lt;p&gt;Left&lt;/p&gt;
                &lt;.divider orientation="vertical" class="h-full" /&gt;
                &lt;p&gt;Right&lt;/p&gt;
              &lt;/div&gt;

              &lt;!-- Vertical with label --&gt;
              &lt;.divider orientation="vertical" label="OR" class="h-full" /&gt;</code></pre>
            </div>
          </section>
          
    <!-- Future components will be added here -->
        </div>
      </main>
      
    <!-- Back to Top Button -->
      <button
        id="back-to-top"
        phx-click={JS.dispatch("scroll-to-top")}
        class={[
          "fixed bottom-8 right-8 size-12 rounded-full",
          "bg-primary-500 text-white shadow-lg",
          "hover:bg-primary-600 transition-all duration-200",
          "flex items-center justify-center",
          "opacity-0 invisible",
          "z-50"
        ]}
        aria-label="Back to top"
      >
        <svg class="size-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M5 10l7-7m0 0l7 7m-7-7v18"
          />
        </svg>
      </button>

      <script type="text/javascript">
        (() => {
          const button = document.getElementById('back-to-top');
          const container = document.getElementById('theme-container');

          if (!button || !container) return;

          window.addEventListener('scroll', () => {
            if (window.scrollY > 300) {
              button.classList.remove('opacity-0', 'invisible');
            } else {
              button.classList.add('opacity-0', 'invisible');
            }
          });

          window.addEventListener('scroll-to-top', () => {
            container.scrollIntoView({ behavior: 'smooth', block: 'start' });
          });
        })();
      </script>
    </div>
    """
  end

  def handle_event("toggle_theme", _, socket) do
    new_theme = if socket.assigns.theme == "light", do: "dark", else: "light"

    socket =
      socket
      |> assign(theme: new_theme)
      |> push_event("toggle-theme", %{})

    {:noreply, socket}
  end
end
