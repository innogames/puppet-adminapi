#
# Serveradmin attribute restriction
#
# Copyright (c) 2017, InnoGames GmbH
#
type Ig::Server::Attribute_restrict = Variant[
    Ig::Server::Attribute_id,
    Hash[Ig::Server::Attribute_id, Array[Ig::Server::Attribute_restrict], 1, 1],
]
