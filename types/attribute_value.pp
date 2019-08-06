#
# Serveradmin attribute value
#
# Copyright (c) 2019 InnoGames GmbH
#
type Adminapi::Attribute_value = Variant[
    Undef,
    Boolean,
    Numeric,
    Pattern[/\A[^\(\)\'"]+\Z/],
    Array[Numeric],
    Array[Pattern[/\A[^\(\)\'"]+\Z/]],
    Hash[Adminapi::Attribute_id, Adminapi::Attribute_value],
    Array[Hash[Adminapi::Attribute_id, Adminapi::Attribute_value]],
]
