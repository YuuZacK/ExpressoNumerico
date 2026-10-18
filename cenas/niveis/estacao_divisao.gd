extends Node2D

@onready var hud = $HUD
@onready var caixa_resposta = $CaixaDeResposta
@onready var caixa_calculo = $CaixaCalculo

@export var niveis: Array[Dictionary] = [
	{"nivel": 1,
	 "calculo": "2 / 2",
	 "resultado": 1
	},
	
	{"nivel": 2,
	 "calculo": "10 / 5",
	 "resultado": 2
	},
	
	{"nivel": 3,
	 "calculo": "6 / 2 ",
	 "resultado": 3
	},
	
	{"nivel": 4,
	"calculo": "8 / 2",
	"resultado": 4
	},
	
	{"nivel": 5, 
	"calculo": "10 / 10",
	"resultado": 5
	},
	
	{"nivel": 6,
	 "calculo": "24 / 4 ",
	 "resultado": 6
	}
]

var indice_atual: int = 0
var nivel_atual: Dictionary = {}
var aguardando_transicao: bool = false


func _ready() -> void:
	if caixa_resposta and not caixa_resposta.text_changed.is_connected(_on_caixa_de_resposta_text_changed):
		caixa_resposta.text_changed.connect(_on_caixa_de_resposta_text_changed)

	carregar_nivel_atual()


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
		
		# Reinicia o tempo para 99.9 ao entrar na fase e a cada nova conta
		hud.atualizar_tempo(99.9)
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

		hud.atualizar_pontos(Global.pontos)
		hud.atualizar_acertos(Global.acertos, niveis.size())

		# Pausa de 1 segundo para feedback visual
		await get_tree().create_timer(1.0).timeout
		if not is_inside_tree():
			return

		# Reseta o tempo no HUD antes de passar para a próxima conta
		hud.atualizar_tempo(99.9)

		indice_atual += 1
		carregar_nivel_atual()


func finalizar_fase() -> void:
	caixa_resposta.editable = false
	caixa_resposta.text = ""
	caixa_calculo.text = "Parabéns!!!"
	print("Fase de multiplicação concluída com sucesso!")

	await get_tree().create_timer(1.2).timeout
	if is_inside_tree():
		get_tree().change_scene_to_file("res://cenas/niveis/tela_vitoria.tscn")
