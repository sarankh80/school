<?php
return [
    'datagrid' => [
        'actions' => 'Действия',
        'id'      => 'Столбцы индекса имеют только значение больше нуля',

        'massaction' => [
            'mass-delete-confirm'     => 'Вы действительно хотите удалить эти выбранные :resource?',
            'mass-update-status'      => 'Вы действительно хотите обновить статус этих выбранных :resource?',
            'delete'                  => 'Вы действительно хотите выполнить это действие?',
            'edit'                    => 'Вы действительно хотите отредактировать это :resource?',
            'delete-category-product' => 'Выбранные категории содержат товары. Выполнение этого действия приведет к удалению связанных продуктов. Вы действительно хотите выполнить это действие?',
        ],

        'error' => [
            'multiple-sort-keys-error'   => 'Фатальная ошибка! Найдено несколько ключей сортировки, исправьте URL-адрес вручную',
            'multiple-search-keys-error' => 'Найдено несколько ключей поиска, исправьте URL-адрес вручную',
            'mapped-keys-error'          => 'Сопоставленный ключ не найден. Убедитесь, что вы указали допустимые параметры.',
        ],

        'zero-index'            => 'Столбцы индекса могут иметь только значения больше нуля',
        'no-records'            => 'Записей не найдено',
        'filter-fields-missing' => 'Некоторые из обязательных полей пусты, пожалуйста, проверьте правильность столбца, условия и значения',
        'filter-exists'         => 'Значение фильтра уже существует.',
        'click_on_action'       => 'Вы действительно хотите выполнить это действие?',
        'search'                => 'Поищи здесь...',
        'search-title'          => 'Поиск',
        'channel'               => 'Канал',
        'locale'                => 'локаль',
        'customer-group'        => 'Группа клиентов',
        'filter'                => 'Фильтр',
        'column'                => 'Выбрать столбец',
        'condition'             => 'Выберите условие',
        'contains'              => 'Содержит',
        'ncontains'             => 'Не содержит',
        'equals'                => 'равно ',
        'nequals'               => 'Не равно',
        'greater'               => 'Лучше чем',
        'less'                  => 'Меньше, чем',
        'greatere'              => 'Больше, чем равно',
        'lesse'                 => 'Меньше, чем равно',
        'value'                 => 'Выберите значение',
        'true'                  => 'Истинный / Активный',
        'false'                 => 'Ложь / Неактивно',
        'between'               => 'Находится между',
        'apply'                 => 'Подать заявление',
        'items-per-page'        => 'Пункты на странице',
        'value-here'            => 'Значение здесь',
        'numeric-value-here'    => 'Числовое значение здесь',
        'submit'                => 'Представлять на рассмотрение',
        'edit'                  => 'Редактировать',
        'delete'                => 'Удалить',
        'view'                  => 'Вид',
        'active'                => 'активный',
        'inactive'              => 'Неактивный',
        'all-channels'          => 'Все каналы',
        'all-locales'           => 'Все локали',
        'all-customer-groups'   => 'Все группы клиентов',
        'records-found'         => 'Запись(и) найдена',
        'clear-all'             => 'Очистить все'
    ],
];