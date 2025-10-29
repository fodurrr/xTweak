const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    '../lib/**/*.{ex,exs,heex}',
  ],
  theme: {
    extend: {
      colors: {
        // Map CSS variables to Tailwind colors
        primary: {
          50: 'var(--color-primary-50)',
          100: 'var(--color-primary-100)',
          200: 'var(--color-primary-200)',
          300: 'var(--color-primary-300)',
          400: 'var(--color-primary-400)',
          500: 'var(--color-primary-500)',
          600: 'var(--color-primary-600)',
          700: 'var(--color-primary-700)',
          800: 'var(--color-primary-800)',
          900: 'var(--color-primary-900)',
        },
        gray: {
          50: 'var(--color-gray-50)',
          100: 'var(--color-gray-100)',
          200: 'var(--color-gray-200)',
          300: 'var(--color-gray-300)',
          400: 'var(--color-gray-400)',
          500: 'var(--color-gray-500)',
          600: 'var(--color-gray-600)',
          700: 'var(--color-gray-700)',
          800: 'var(--color-gray-800)',
          900: 'var(--color-gray-900)',
        },
        'ui-bg': {
          default: 'var(--ui-bg-default)',
          elevated: 'var(--ui-bg-elevated)',
          accented: 'var(--ui-bg-accented)',
        },
        'ui-text': {
          default: 'var(--ui-text-default)',
          dimmed: 'var(--ui-text-dimmed)',
          muted: 'var(--ui-text-muted)',
          highlighted: 'var(--ui-text-highlighted)',
        },
        'ui-border': {
          default: 'var(--ui-border-default)',
          accented: 'var(--ui-border-accented)',
        }
      },
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      borderRadius: {
        'ui': 'var(--ui-radius)',
        'ui-sm': 'var(--ui-radius-sm)',
        'ui-lg': 'var(--ui-radius-lg)',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
  ],
}
