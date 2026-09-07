extends Node

var teams: Array = [
	{"name": "Kızıl Şahinler", "primary_color": Color8(193, 39, 45), "secondary_color": Color8(255, 255, 255)},
	{"name": "Gece Kartalları", "primary_color": Color8(27, 27, 58), "secondary_color": Color8(244, 196, 48)},
	{"name": "Çelik Kaplanlar", "primary_color": Color8(46, 46, 46), "secondary_color": Color8(255, 127, 17)},
	{"name": "Deniz Yıldızları", "primary_color": Color8(0, 91, 150), "secondary_color": Color8(255, 215, 0)},
	{"name": "Orman Kurtları", "primary_color": Color8(20, 90, 50), "secondary_color": Color8(253, 254, 253)},
	{"name": "Volkan Aslanları", "primary_color": Color8(169, 50, 38), "secondary_color": Color8(241, 196, 15)},
	{"name": "Buz Ejderleri", "primary_color": Color8(21, 67, 96), "secondary_color": Color8(174, 214, 241)},
	{"name": "Altın Şahinler", "primary_color": Color8(183, 149, 11), "secondary_color": Color8(28, 40, 51)}
]

func get_team(team_index: int) -> Dictionary:
	return teams[team_index]

func get_team_count() -> int:
	return teams.size()
