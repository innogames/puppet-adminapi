#
# Serveradmin attribute restriction
#
# Copyright (c) 2019 InnoGames GmbH
#
type Adminapi::Attribute_restrict = Variant[
    Adminapi::Attribute_id,
    Hash[Adminapi::Attribute_id, Array[Adminapi::Attribute_restrict], 1, 1],
]
