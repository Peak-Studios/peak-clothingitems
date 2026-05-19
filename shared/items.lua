--[[
    Clothing Slot Definitions
    Maps every GTA V clothing component and prop slot to an inventory item.

    Components use SetPedComponentVariation / GetPedDrawableVariation
    Props use SetPedPropIndex / GetPedPropIndex / ClearPedProp

    defaultDrawable/defaultTexture = the "naked/bare" value for that slot.
    Components default to drawable 0, texture 0 (base underwear/bare state).
    Props default to -1 (no prop equipped).
]]

ClothingItems = {}

-- ============================================================
-- COMPONENT SLOTS (SetPedComponentVariation)
-- ============================================================

ClothingItems.Components = {
    {
        id = 1,
        name = 'clothing_mask',
        label = 'Mask',
        alias = 'mask',
        icon = 'theater-masks',
        defaultDrawable = 0,
        defaultTexture = 0,
    },
    {
        id = 3,
        name = 'clothing_torso',
        label = 'Torso',
        alias = 'torso',
        icon = 'vest',
        defaultDrawable = 0,
        defaultTexture = 0,
    },
    {
        id = 4,
        name = 'clothing_pants',
        label = 'Pants',
        alias = 'pants',
        icon = 'socks', -- closest FA icon
        defaultDrawable = 0,
        defaultTexture = 0,
    },
    {
        id = 5,
        name = 'clothing_bag',
        label = 'Bag',
        alias = 'bag',
        icon = 'bag-shopping',
        defaultDrawable = 0,
        defaultTexture = 0,
    },
    {
        id = 6,
        name = 'clothing_shoes',
        label = 'Shoes',
        alias = 'shoes',
        icon = 'shoe-prints',
        defaultDrawable = 0,
        defaultTexture = 0,
    },
    {
        id = 7,
        name = 'clothing_accessory',
        label = 'Accessory',
        alias = 'accessory',
        icon = 'gem',
        defaultDrawable = 0,
        defaultTexture = 0,
    },
    {
        id = 8,
        name = 'clothing_undershirt',
        label = 'Undershirt',
        alias = 'undershirt',
        icon = 'shirt',
        defaultDrawable = 0,
        defaultTexture = 0,
    },
    {
        id = 9,
        name = 'clothing_vest',
        label = 'Vest',
        alias = 'vest',
        icon = 'shield-halved',
        defaultDrawable = 0,
        defaultTexture = 0,
    },
    {
        id = 10,
        name = 'clothing_decal',
        label = 'Decal',
        alias = 'decal',
        icon = 'palette',
        defaultDrawable = 0,
        defaultTexture = 0,
    },
    {
        id = 11,
        name = 'clothing_top',
        label = 'Top',
        alias = 'top',
        icon = 'jacket',
        defaultDrawable = 0,
        defaultTexture = 0,
    },
}

-- ============================================================
-- PROP SLOTS (SetPedPropIndex / ClearPedProp)
-- ============================================================

ClothingItems.Props = {
    {
        id = 0,
        name = 'clothing_hat',
        label = 'Hat',
        alias = 'hat',
        icon = 'hat-cowboy',
        defaultDrawable = -1,
        defaultTexture = -1,
    },
    {
        id = 1,
        name = 'clothing_glasses',
        label = 'Glasses',
        alias = 'glasses',
        icon = 'glasses',
        defaultDrawable = -1,
        defaultTexture = -1,
    },
    {
        id = 2,
        name = 'clothing_earring',
        label = 'Earring',
        alias = 'earring',
        icon = 'ear-listen',
        defaultDrawable = -1,
        defaultTexture = -1,
    },
    {
        id = 6,
        name = 'clothing_watch',
        label = 'Watch',
        alias = 'watch',
        icon = 'clock',
        defaultDrawable = -1,
        defaultTexture = -1,
    },
    {
        id = 7,
        name = 'clothing_bracelet',
        label = 'Bracelet',
        alias = 'bracelet',
        icon = 'ring',
        defaultDrawable = -1,
        defaultTexture = -1,
    },
}

-- ============================================================
-- LOOKUP TABLES (built at load time)
-- ============================================================

ClothingItems._byName = {}
ClothingItems._byAlias = {}
ClothingItems._componentById = {}
ClothingItems._propById = {}

for _, slot in ipairs(ClothingItems.Components) do
    ClothingItems._byName[slot.name] = { slot = slot, type = 'component' }
    ClothingItems._byAlias[slot.alias] = { slot = slot, type = 'component' }
    ClothingItems._componentById[slot.id] = slot
end

for _, slot in ipairs(ClothingItems.Props) do
    ClothingItems._byName[slot.name] = { slot = slot, type = 'prop' }
    ClothingItems._byAlias[slot.alias] = { slot = slot, type = 'prop' }
    ClothingItems._propById[slot.id] = slot
end

-- ============================================================
-- DYNAMIC DEFAULT (NAKED/BARE) VALUES
-- ============================================================

ClothingItems.DefaultValues = {
    ['mp_m_freemode_01'] = {
        components = {
            [1]  = { drawable = 0,  texture = 0 },  -- Mask
            [3]  = { drawable = 15, texture = 0 },  -- Torso/Arms
            [4]  = { drawable = 21, texture = 0 },  -- Pants
            [5]  = { drawable = 0,  texture = 0 },  -- Bag
            [6]  = { drawable = 34, texture = 0 },  -- Shoes
            [7]  = { drawable = 0,  texture = 0 },  -- Accessory
            [8]  = { drawable = 15, texture = 0 },  -- Undershirt
            [9]  = { drawable = 0,  texture = 0 },  -- Vest
            [10] = { drawable = 0,  texture = 0 },  -- Decal
            [11] = { drawable = 15, texture = 0 },  -- Top
        },
        props = {
            [0] = { drawable = -1, texture = -1 }, -- Hat
            [1] = { drawable = -1, texture = -1 }, -- Glasses
            [2] = { drawable = -1, texture = -1 }, -- Earring
            [6] = { drawable = -1, texture = -1 }, -- Watch
            [7] = { drawable = -1, texture = -1 }, -- Bracelet
        }
    },
    ['mp_f_freemode_01'] = {
        components = {
            [1]  = { drawable = 0,  texture = 0 },  -- Mask
            [3]  = { drawable = 15, texture = 0 },  -- Torso/Arms
            [4]  = { drawable = 15, texture = 0 },  -- Pants
            [5]  = { drawable = 0,  texture = 0 },  -- Bag
            [6]  = { drawable = 35, texture = 0 },  -- Shoes
            [7]  = { drawable = 0,  texture = 0 },  -- Accessory
            [8]  = { drawable = 15, texture = 0 },  -- Undershirt
            [9]  = { drawable = 0,  texture = 0 },  -- Vest
            [10] = { drawable = 0,  texture = 0 },  -- Decal
            [11] = { drawable = 15, texture = 0 },  -- Top
        },
        props = {
            [0] = { drawable = -1, texture = -1 }, -- Hat
            [1] = { drawable = -1, texture = -1 }, -- Glasses
            [2] = { drawable = -1, texture = -1 }, -- Earring
            [6] = { drawable = -1, texture = -1 }, -- Watch
            [7] = { drawable = -1, texture = -1 }, -- Bracelet
        }
    }
}

--- Returns the default (naked/bare) values for a slot based on model name.
--- @param model string
--- @param slotType string "component" or "prop"
--- @param slotId number
--- @return number defaultDrawable, number defaultTexture
function ClothingItems.GetDefaultValues(model, slotType, slotId)
    local fallbackDrawable = (slotType == 'component') and 0 or -1
    local fallbackTexture = (slotType == 'component') and 0 or -1

    local modelData = ClothingItems.DefaultValues[model]
    if not modelData then
        if model == 'male' then
            modelData = ClothingItems.DefaultValues['mp_m_freemode_01']
        elseif model == 'female' then
            modelData = ClothingItems.DefaultValues['mp_f_freemode_01']
        end
    end

    if not modelData then return fallbackDrawable, fallbackTexture end

    local list = (slotType == 'component') and modelData.components or modelData.props
    local entry = list[slotId]
    if not entry then return fallbackDrawable, fallbackTexture end

    return entry.drawable, entry.texture
end

