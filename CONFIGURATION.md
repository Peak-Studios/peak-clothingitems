# Configuration

All user-facing options live in `shared/config.lua`.

## System Detection

| Option | Default | Values |
| :--- | :--- | :--- |
| `Config.Framework` | `'auto'` | `'auto'`, `'qbcore'`, `'qbox'`, `'esx'`, `'standalone'` |
| `Config.Inventory` | `'auto'` | `'auto'`, `'ox_inventory'`, `'qb-inventory'`, `'qs-inventory'`, `'codem-inventory'`, `'ps-inventory'` |
| `Config.Appearance` | `'auto'` | `'auto'`, `'illenium-appearance'`, `'rcore_clothing'`, `'fivem-appearance'`, `'skinchanger'` |
| `Config.Notify` | `'auto'` | `'auto'`, `'ox_lib'`, `'qb-core'`, `'esx'`, `'native'` |
| `Config.RadialMenu` | `'auto'` | `'auto'`, `'ox_lib'`, `'qb-radialmenu'`, `'none'` |

Use `auto` unless your server has multiple compatible resources running.

## Commands

| Option | Default | Description |
| :--- | :--- | :--- |
| `Config.Command` | `'clothing'` | Base player command. |
| `Config.AllowRemoveAll` | `true` | Enables `/clothing remove all`. |

## Items

| Option | Default | Description |
| :--- | :--- | :--- |
| `Config.ItemPrefix` | `'clothing_'` | Naming convention for bundled item definitions. |
| `Config.DefaultWeight` | `100` | Default weight reference for clothing definitions. |

The included slot definitions currently use explicit item names in `shared/items.lua`. If you rename items, update both `shared/items.lua` and the inventory definitions in `install/`.

## Behavior

| Option | Default | Description |
| :--- | :--- | :--- |
| `Config.Cooldown` | `2000` | Client and server cooldown in milliseconds between conversion actions. |
| `Config.EnableRadialMenu` | `true` | Enables supported radial menu registration. |
| `Config.Locale` | `'en'` | Active locale file. |
| `Config.Debug` | `false` | Prints extra diagnostics to console. |

## Clothing Defaults

Default bare values are defined in `shared/items.lua` under `ClothingItems.DefaultValues`. Adjust them if your server uses custom base clothing packs where the default bare drawable differs from the included freemode defaults.
