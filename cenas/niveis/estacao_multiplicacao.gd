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
	for i in max_niveis:
		var valor1: int = randi_range(1, 10)
		var valor2: int = randi_range(1, 10)
		
		var texto_calculo: String = "{v1} x {v2}".format({"v1": valor1, "v2": valor2})
		var conta_resultado: int = valor1 * valor2
		
		niveis.append({
			"nivel": i + 1,
			"calculo": texto_calculo,
			"resultado": conta_resultado
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

	if not new_text.is_valid_int() and new_text != "":
		caixa_resposta.text = new_text.left(-1)
		caixa_resposta.caret_column = caixa_resposta.text.length()
		return

	if new_text != "" and new_text.to_int() == int(nivel_atual["resultado"]):
		aguardando_transicao = true
		caixa_resposta.editable = false

		Global.pontos += 10
		Global.acertos += 1

		var tempo_usado = hud.tempo_maximo - hud.tempo_atual
		Global.tempo_gasto += int(tempo_usado)

		hud.atualizar_pontos(Global.pontos)
		hud.atualizar_acertos(Global.acertos, niveis.size())

		await get_tree().create_timer(1.0).timeout
		if not is_inside_tree():
			return
			
		hud.tempo_atual = hud.tempo_maximo

		indice_atual += 1
		carregar_nivel_atual()

func finalizar_fase() -> void:
	caixa_resposta.editable = false
	caixa_resposta.text = ""
	caixa_calculo.text = "Parabéns!!!"
	print("Fase de multiplicação concluída com sucesso!")
	
	# Grava o trilho para a próxima fase (Divisão) antes de abrir a vitória
	Global.proxima_estacao = "res://cenas/niveis/estacao-divisao.tscn"

	get_tree().change_scene_to_file("res://cenas/niveis/tela_vitoria.tscn")
