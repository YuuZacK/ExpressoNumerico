extends Node2D

@onready var hud = $HUD
@onready var caixa_resposta = $CaixaDeResposta
@onready var caixa_calculo = $CaixaCalculo

@export var niveis: Array[Dictionary] = [
	{"nivel": 1,
	 "calculo": "2 x 2",
	 "resultado": 4
	},
	
	{"nivel": 2,
	 "calculo": "5 x 2",
	 "resultado": 10
	},
	
	{"nivel": 3,
	 "calculo": "3 x 4",
	 "resultado": 12
	},
	
	{"nivel": 4,
	"calculo": "6 x 3",
	"resultado": 18
	},
	
	{"nivel": 5, 
	"calculo": "4 x 4",
	"resultado": 16
	},
	
	{"nivel": 6,
	 "calculo": "7 x 5",
	 "resultado": 35
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
