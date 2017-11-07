#
# Query for igserver
#
# Copyright (c) 2017, InnoGames GmbH
#
type Ig::Igserver_query = Hash[Ig::Attribute_id, Variant[
    Boolean,
    Numeric,
    Pattern[/\A[^\(\)\'"]+\Z/],
    Ig::Igserver_query_filter,
]]
