if Config.Locale ~= 'en' then return end

Locales = {
    -- Removal
    ['removed_clothing']     = 'You removed your %s',
    ['removed_all_clothing'] = 'You removed all your clothing',
    ['partial_remove']       = 'Removed %d clothing item(s). Your inventory filled before the rest could be removed',
    ['already_default']      = 'You are not wearing anything in that slot',
    ['nothing_to_remove']    = 'You have nothing to remove',

    -- Wearing
    ['wearing_clothing']     = 'You put on a %s',
    ['wrong_model']          = 'This clothing is not compatible with your character',
    ['slot_occupied']        = 'You are already wearing something in that slot. Remove it first',

    -- Errors
    ['cooldown']             = 'Please wait before performing another clothing action',
    ['no_item']              = 'You don\'t have this item',
    ['inventory_full']       = 'Your inventory is full',
    ['invalid_metadata']     = 'This clothing item is damaged and cannot be worn',
    ['invalid_slot']         = 'Unknown clothing slot: %s',
    ['action_failed']        = 'Something went wrong. Please try again',

    -- Commands
    ['cmd_help']             = 'Usage: /%s remove <slot|all> — Slots: %s',
    ['cmd_list_header']      = 'Currently wearing:',
    ['cmd_list_empty']       = 'You are not wearing any removable clothing',
    ['cmd_list_item']        = '  %s: Drawable %d, Texture %d',

    -- Radial Menu
    ['radial_clothing']      = 'Clothing',
    ['radial_remove']        = 'Remove Clothing',
    ['radial_remove_all']    = 'Remove All',

    -- Admin
    ['admin_give_usage']     = 'Usage: /%s give <player_id> <slot> <drawable> <texture>',
    ['admin_give_success']   = 'Gave %s (drawable: %d, texture: %d) to player %d',
    ['admin_no_permission']  = 'You do not have permission to use this command',
}
