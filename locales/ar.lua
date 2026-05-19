if Config.Locale ~= 'ar' then return end

Locales = {
    -- إزالة
    ['removed_clothing']     = 'لقد خلعت %s',
    ['removed_all_clothing'] = 'لقد خلعت جميع ملابسك',
    ['partial_remove']       = 'تم خلع %d عنصر/عناصر. امتلأت حقيبتك قبل خلع الباقي',
    ['already_default']      = 'أنت لا ترتدي شيئاً في هذه الخانة',
    ['nothing_to_remove']    = 'ليس لديك شيء لخلعه',

    -- ارتداء
    ['wearing_clothing']     = 'لقد ارتديت %s',
    ['wrong_model']          = 'هذه الملابس غير متوافقة مع شخصيتك',
    ['slot_occupied']        = 'أنت ترتدي شيئاً بالفعل في هذه الخانة. اخلعه أولاً',

    -- أخطاء
    ['cooldown']             = 'يرجى الانتظار قبل القيام بإجراء آخر للملابس',
    ['no_item']              = 'ليس لديك هذا العنصر',
    ['inventory_full']       = 'حقيبتك ممتلئة',
    ['invalid_metadata']     = 'هذه الملابس تالفة ولا يمكن ارتداؤها',
    ['invalid_slot']         = 'خانة ملابس غير معروفة: %s',
    ['action_failed']        = 'حدث خطأ ما. يرجى المحاولة مرة أخرى',

    -- الأوامر
    ['cmd_help']             = 'الاستخدام: /%s remove <خانة|all> — الخانات: %s',
    ['cmd_list_header']      = 'الملابس الحالية:',
    ['cmd_list_empty']       = 'أنت لا ترتدي أي ملابس قابلة للإزالة',
    ['cmd_list_item']        = '  %s: Drawable %d, Texture %d',

    -- القائمة الدائرية
    ['radial_clothing']      = 'الملابس',
    ['radial_remove']        = 'خلع ملابس',
    ['radial_remove_all']    = 'خلع الكل',

    -- المشرف
    ['admin_give_usage']     = 'الاستخدام: /%s give <معرف_اللاعب> <خانة> <drawable> <texture>',
    ['admin_give_success']   = 'تم إعطاء %s (drawable: %d, texture: %d) للاعب %d',
    ['admin_no_permission']  = 'ليس لديك صلاحية لاستخدام هذا الأمر',
}
