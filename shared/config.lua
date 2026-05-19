Config = Config or {}

-- ============================================================
-- FRAMEWORK & SYSTEM DETECTION
-- ============================================================

-- Framework: 'auto' will detect qbcore/qbox/esx automatically.
Config.Framework = 'auto' -- 'auto', 'qbcore', 'esx', 'qbox', 'standalone'

-- Inventory system: 'auto' scans for running inventory resources.
Config.Inventory = 'auto' -- 'auto', 'ox_inventory', 'qb-inventory', 'qs-inventory', 'codem-inventory', 'ps-inventory'

-- Appearance/clothing resource: 'auto' detects the running appearance system.
Config.Appearance = 'auto' -- 'auto', 'illenium-appearance', 'rcore_clothing', 'fivem-appearance', 'skinchanger'

-- Notification system: 'auto' detects ox_lib > qb-core > esx > native.
Config.Notify = 'auto' -- 'auto', 'ox_lib', 'qb-core', 'esx', 'native'

-- Radial menu system: 'auto' detects ox_lib > qb-radialmenu. Set 'none' to disable.
Config.RadialMenu = 'auto' -- 'auto', 'ox_lib', 'qb-radialmenu', 'none'

-- ============================================================
-- COMMANDS
-- ============================================================

-- Base command name. Usage: /clothing remove <slot>, /clothing remove all
Config.Command = 'clothing'

-- Enable /clothing remove all (removes everything at once)
Config.AllowRemoveAll = true

-- ============================================================
-- ITEMS
-- ============================================================

-- Prefix for all clothing item names (e.g. clothing_hat, clothing_pants)
Config.ItemPrefix = 'clothing_'

-- Default weight in grams for each clothing piece
Config.DefaultWeight = 100

-- ============================================================
-- BEHAVIOR
-- ============================================================

-- Cooldown in milliseconds between clothing actions (prevents spam)
Config.Cooldown = 2000

-- Enable radial menu integration (requires a supported radial menu resource)
Config.EnableRadialMenu = true

-- ============================================================
-- LOCALE
-- ============================================================

-- Active locale. Included: 'en', 'fr', 'es', 'ar'
Config.Locale = 'en'

-- ============================================================
-- DEBUG
-- ============================================================

-- Set true to print extra diagnostics to console
Config.Debug = false

-- [AI-FIRST SETUP]: Give PROMPT.md to your AI coding agent for easy installation.
