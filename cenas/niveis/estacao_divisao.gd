extends Node2D

@onready var hud = $HUD
@onready var caixa_resposta = $CaixaDeResposta
@onready var caixa_calculo = $CaixaCalculo

@export var max_niveis: int = 6
@export var niveis: Array[Dictionary] = []

var indice_atual: int = 0
var nivel_atual: Dictionary = {}
var aguardando_transicao: bool = false

func _ready() -> void:
	if caixa_resposta and not caixa_resposta.text_changed.is_connected(_on_caixa_de_resposta_text_changed):
		caixa_resposta.text_changed.connect(_on_caixa_de_resposta_text_changed)
	
	carregar_perguntas()
	carregar_nivel_atual()

func carregar_perguntas() -> void:
	# Garante contas de divisão com resultados inteiros exatos
	for i in max_niveis:
		var divisor: int = randi_range(1, 10)
		var quociente: int = randi_range(1, 10)
		var dividendo: int = divisor * quociente # Ex: Se sorteou 3 e 4, a conta será 12 ÷ 3
		
		var texto_calculo: String = "{v1} ÷ {v2}".format({"v1": dividendo, "v2": divisor})
		
		niveis.append({
			"nivel": i + 1,
			"calculo": texto_calculo,
			"resultado": quociente # O resultado exato que a criança precisa digitar
		})
	print(niveis)

func carregar_nivel_atual() -> void:
	if indice_atual < niveis.size():
		nivel_atual = niveis[indice_atual]
		caixa_resposta.text = ""
		caixa_resposta.editable = true
		caixa_resposta.grab_focus()
		aguardando_transicao = false

		caixa_calculo.text = str(nivel_atual["calculo"])

		hud.atualizar_pontos(Global.pontos)
		hud.atualizar_acertos(Global.acertos, niveis.size())
	else:
		finalizar_fase()

func _on_caixa_de_resposta_text_changed(new_text: String) -> void:
	if aguardando_transicao:
		return

	# Filtro para números inteiros
	if not new_text.is_valid_int() and new_text != "":
		caixa_resposta.text = new_text.left(-1)
		caixa_resposta.caret_column = caixa_resposta.text.length()
		return

	# Validação da resposta
	if new_text != "" and new_text.to_int() == int(nivel_atual["resultado"]):
		aguardando_transicao = true
		caixa_resposta.editable = false

		Global.pontos += 10
		Global.acertos += 1

		# Calcula o tempo usado nesta conta e soma no valor global
		var tempo_usado = hud.tempo_maximo - hud.tempo_atual
		Global.tempo_gasto += int(tempo_usado)

		hud.atualizar_pontos(Global.pontos)
		hud.atualizar_acertos(Global.acertos, niveis.size())

		# Pausa de 1 segundo para feedback visual
		await get_tree().create_timer(1.0).timeout
		if not is_inside_tree():
			return

		indice_atual += 1
		carregar_nivel_atual()

func finalizar_fase() -> void:
	caixa_resposta.editable = false
	caixa_resposta.text = ""
	caixa_calculo.text = "Parabéns!!!"
	print("Fase de divisão concluída com sucesso!")

	await get_tree().create_timer(1.2).timeout
	if is_inside_tree():
		get_tree().change_scene_to_file("res://cenas/niveis/tela_vitoria.tscn")
