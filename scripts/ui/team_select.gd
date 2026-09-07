extends Control

@onready var grid_container: GridContainer = $MarginContainer/VBoxContainer/ScrollContainer/GridContainer

func _ready() -> void:
	for team_index in range(TeamData.get_team_count()):
		var team: Dictionary = TeamData.get_team(team_index)
		var team_button: Button = Button.new()
		team_button.text = team["name"]
		team_button.custom_minimum_size = Vector2(280, 90)
		team_button.add_theme_color_override("font_color", team["secondary_color"])
		var style_box_normal: StyleBoxFlat = StyleBoxFlat.new()
		style_box_normal.bg_color = team["primary_color"]
		style_box_normal.corner_radius_top_left = 12
		style_box_normal.corner_radius_top_right = 12
		style_box_normal.corner_radius_bottom_left = 12
		style_box_normal.corner_radius_bottom_right = 12
		team_button.add_theme_stylebox_override("normal", style_box_normal)
		var style_box_hover: StyleBoxFlat = style_box_normal.duplicate()
		style_box_hover.bg_color = team["primary_color"].lightened(0.15)
		team_button.add_theme_stylebox_override("hover", style_box_hover)
		team_button.pressed.connect(_on_team_selected.bind(team_index))
		grid_container.add_child(team_button)

func _on_team_selected(team_index: int) -> void:
	GameManager.selected_team_index = team_index
	GameManager.start_new_tournament()
	get_tree().change_scene_to_file("res://scenes/Match.tscn")
