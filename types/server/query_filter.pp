#
# Serveradmin query filter
#
# The filters are represented as single item hashes.
#
# Copyright (c) 2017, InnoGames GmbH
#
type Ig::Server::Query_filter = Variant[
    # The list is ordered relatively from simple to complicated.
    Boolean,
    Numeric,
    Pattern[/\A[^\(\)\'"]+\Z/],
    Hash[Enum['Empty'], Undef, 1, 1],
    Hash[Enum['GreaterThan', 'GreaterThanOrEquals', 'LessThan', 'LessThanOrEquals'], Variant[Numeric, Pattern[/\A[^\(\)\'"]+\Z/]], 1, 1],
    Hash[Enum['Regexp'], String[1], 1, 1],
    Hash[Enum['Overlaps', 'ContainedBy', 'ContainedOnlyBy', 'Contains', 'StartsWith'], Pattern[/\A[^\(\)\'"]+\Z/], 1, 1],
    Hash[Enum['Any', 'All'], Array[Ig::Server::Query_filter], 1, 1],
    Hash[Enum['Not'], Ig::Server::Query_filter, 1, 1],
]
