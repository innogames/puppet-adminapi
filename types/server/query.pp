#
# Serveradmin query
#
# Copyright (c) 2017, InnoGames GmbH
#
type Ig::Server::Query = Hash[Ig::Server::Attribute_id, Variant[
    Boolean,
    Numeric,
    Pattern[/\A[^\(\)\'"]+\Z/],
    Ig::Server::Query_filter,
]]
