#
# Query filter for igserver
#
# The filters are represented as single item hashes.
#
# Copyright (c) 2017, InnoGames GmbH
#
type Ig::Query_filter = Variant[
    # The list is ordered relatively from simple to complicated.
    Boolean,
    Numeric,
    Pattern[/\A[^\(\)\'"]+\Z/],
    Hash[Enum['Empty'], Undef, 1, 1],
    Hash[Enum['Regexp'], String[1], 1, 1],
    Hash[Enum['Any', 'All'], Array[Ig::Query_filter], 1, 1],
    Hash[Enum['Not'], Ig::Query_filter, 1, 1],
]
