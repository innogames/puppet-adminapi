#
# Hostname datatype
#
# Copyright (c) 2019 InnoGames GmbH
#
type Adminapi::Hostname = Pattern[/\A(\*\.)?([a-z0-9]+(\.|-+))*[a-z0-9]+\Z/]
