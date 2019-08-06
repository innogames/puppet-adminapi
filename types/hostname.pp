#
# Hostname datatype
#
# Copyright (c) 2019 InnoGames GmbH
#
type Adminapi::Hostname = Pattern[/\A[a-z][a-z0-9_\-\.]+\Z/]
