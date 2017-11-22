#
# Domain name datatype
#
# Copyright (c) 2017, InnoGames GmbH
#
type Ig::Domain_name = Pattern[/\A[a-z][a-z0-9_\-\.]+\Z/]
