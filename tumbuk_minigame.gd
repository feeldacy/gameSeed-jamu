extends Node3D

@onready var symbol_label = $CanvasLayer/SymbolLabel
@onready var score_label = $CanvasLayer/ScoreLabel
@onready var result_label = $CanvasLayer/ResultLabel
@onready var timer = $Timer

@onready var batu_tumbuk = $mangkok/tumbukan
@onready var bahan_jamu = $"jahe-try1"

var score := 0
var max_score := 5
var input_time := 2.0

var current_input = null
var is_playing := true

var possible_inputs = [
	{"text": "W", "action": "press_w"},
	{"text": "A", "action": "press_a"},
	{"text": "S", "action": "press_s"},
	{"text": "D", "action": "press_d"},
	{"text": "1", "action": "press_1"},
	{"text": "2", "action": "press_2"},
	{"text": "3", "action": "press_3"},
	{"text": "DON'T CLICK", "action": "dont_click"}
]


func _ready():
	print("=== MINIGAME TUMBUK DIMULAI ===")
	print("Node SymbolLabel ditemukan: ", symbol_label)
	print("Node ScoreLabel ditemukan: ", score_label)
	print("Node ResultLabel ditemukan: ", result_label)
	print("Node Timer ditemukan: ", timer)
	print("Node BatuTumbuk ditemukan: ", batu_tumbuk)
	print("Node BahanJamu ditemukan: ", bahan_jamu)

	randomize()
	score = 0
	update_score()
	result_label.text = ""
	show_next_symbol()


func show_next_symbol():
	print("--------------------------------")

	if score >= max_score:
		print("Score sudah mencapai maksimal: ", score)
		finish_tumbuk()
		return

	current_input = possible_inputs.pick_random()
	symbol_label.text = current_input["text"]
	result_label.text = ""

	print("Simbol baru muncul: ", current_input["text"])
	print("Action yang benar: ", current_input["action"])
	print("Timer dimulai selama ", input_time, " detik")

	timer.start(input_time)


func _input(event):
	if not is_playing:
		print("Input diabaikan karena minigame sudah selesai")
		return

	if current_input == null:
		print("Input diabaikan karena current_input masih null")
		return

	for input_data in possible_inputs:
		if Input.is_action_just_pressed(input_data["action"]):
			print("User menekan action: ", input_data["action"])
			check_input(input_data["action"])
			break


func check_input(player_action: String):
	print("Mengecek input...")
	print("Input user: ", player_action)
	print("Input yang benar: ", current_input["action"])

	timer.stop()
	print("Timer dihentikan")

	if current_input["action"] == "dont_click":
		print("Salah! Seharusnya DON'T CLICK, tapi user menekan tombol")
		result_label.text = "Salah!"
	else:
		if player_action == current_input["action"]:
			score += 1
			print("Benar! Score bertambah menjadi: ", score)

			result_label.text = "Benar!"
			update_score()
			play_tumbuk_animation()
			update_bahan_visual()
		else:
			print("Salah! Score tetap: ", score)
			result_label.text = "Salah!"

	current_input = null
	print("current_input dikosongkan")

	await get_tree().create_timer(0.5).timeout
	show_next_symbol()


func _on_timer_timeout():
	print("Timer timeout terpanggil")

	if current_input == null:
		print("Timer habis, tapi current_input null. Tidak melakukan apa-apa.")
		return

	print("Simbol saat timer habis: ", current_input["text"])
	print("Action saat timer habis: ", current_input["action"])

	if current_input["action"] == "dont_click":
		score += 1
		print("Benar! User tidak menekan saat DON'T CLICK")
		print("Score sekarang: ", score)

		result_label.text = "Benar!"
		update_score()
		play_tumbuk_animation()
		update_bahan_visual()
	else:
		print("Waktu habis! User tidak menekan tombol yang benar")
		result_label.text = "Waktu habis!"

	current_input = null
	print("current_input dikosongkan setelah timer timeout")

	await get_tree().create_timer(0.5).timeout
	show_next_symbol()


func update_score():
	score_label.text = "Point: " + str(score) + "/" + str(max_score)
	print("UI score diperbarui: ", score_label.text)


func play_tumbuk_animation():
	print("Animasi tumbuk dimainkan")

	var start_pos = batu_tumbuk.position
	print("Posisi awal batu tumbuk: ", start_pos)

	var tween = create_tween()
	tween.tween_property(batu_tumbuk, "position:y", start_pos.y - 0.2, 0.08)
	tween.tween_property(batu_tumbuk, "position:y", start_pos.y, 0.12)


func update_bahan_visual():
	print("Visual bahan jamu diperbarui")
	print("Scale sebelum: ", bahan_jamu.scale)

	bahan_jamu.scale = bahan_jamu.scale * 0.95

	print("Scale sesudah: ", bahan_jamu.scale)


func finish_tumbuk():
	print("=== MINIGAME TUMBUK SELESAI ===")

	is_playing = false
	timer.stop()

	symbol_label.text = "SELESAI"
	result_label.text = "Bahan sudah halus!"

	print("Final score: ", score, "/", max_score)
