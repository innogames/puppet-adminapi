#
# Serveradmin attribute value
#
# Copyright (c) 2017 InnoGames GmbH
#
type Ig::Server::Attribute_value = Variant[
    Undef,
    Boolean,
    Numeric,
    Pattern[/\A[^\(\)\'"]+\Z/],
    Array[Numeric],
    Array[Pattern[/\A[^\(\)\'"]+\Z/]],
    Hash[Ig::Server::Attribute_id, Ig::Server::Attribute_value],
    Array[Hash[Ig::Server::Attribute_id, Ig::Server::Attribute_value]],
]
