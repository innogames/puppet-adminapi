#
# Serveradmin query
#
# Copyright (c) 2019 InnoGames GmbH
#
type Adminapi::Query = Hash[Adminapi::Attribute_id, Variant[
    Boolean,
    Numeric,
    Pattern[/\A[^\(\)\'"]+\Z/],
    Adminapi::Query_filter,
]]
