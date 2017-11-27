#
# Query filter for igserver
#
# The filters are represented as single item hashes.
#
# Copyright (c) 2017, InnoGames GmbH
#
type Ig::Igserver_query_filter = Variant[
    # The list is ordered relatively from simple to complicated.
    Hash[Enum['Empty'], Undef, 1, 1],
    Hash[Enum['Regexp'], String[1], 1, 1],
    Hash[Enum['Any', 'All'], Array[Variant[Numeric, Pattern[/\A[^\(\)\'"]+\Z/], Ig::Igserver_query_filter]], 1, 1],
    Hash[Enum['Not'], Variant[Numeric, Pattern[/\A[^\(\)\'"]+\Z/], Ig::Igserver_query_filter], 1, 1],
]
