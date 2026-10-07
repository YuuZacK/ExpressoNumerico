extends Node2D

@onready var hud = $HUD
@onready var caixa_resposta = $CaixaDeResposta
@onready var caixa_calculo = $CaixaCalculo # Referência ao Label da conta

# Lista de níveis exposta no Inspetor do Godot 4
@export var niveis: Array[Dictionary] = [
	{
		"nivel": 1,
		"calculo": "1-1",
		"resultado": 0
	},
	{
		"nivel": 2,
		"calculo": "2-3",
		"resultado": 1
	},
	{
		"nivel": 3,
		"calculo": "1-3",
		"resultado": 2
	}
]

var indice_atual: int = 0
var nivel_atual: Dictionary = {}
var aguardando_transicao: bool = false

func _ready() -> void:
	carregar_nivel_atual()

## Carrega os dados do nível atual e atualiza a interface
func carregar_nivel_atual() -> void:
	if indice_atual < niveis.size():
		nivel_atual = niveis[indice_atual]
		caixa_resposta.text = ""
		caixa_resposta.editable = true
		aguardando_transicao = false
		
		# Define o texto do Label 'CaixaCalculo' com a conta do nível atual (ex: "1-1")
		caixa_calculo.text = str(nivel_atual["calculo"])
		
		# Atualiza o HUD com pontos e progresso
		hud.atualizar_pontos(Global.pontos)
		hud.atualizar_acertos(Global.acertos, niveis.size())
	else:
		finalizar_fase()

func _on_caixa_de_resposta_text_changed(new_text: String) -> void:
	if aguardando_transicao:
		return

	# Filtro: aceita apenas números inteiros
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
		
		# Pausa de 1 segundo para visualização da resposta
		await get_tree().create_timer(1.0).timeout
		hud.atualizar_tempo(99.9)
		
		# Avança para a próxima conta
		indice_atual += 1
		carregar_nivel_atual()

## Executado ao concluir todas as contas
func finalizar_fase() -> void:
	caixa_resposta.editable = false
	caixa_resposta.text = ""
	caixa_calculo.text = "Parabéns!!!"
	print("Fase concluída com sucesso!")
	
	get_tree().change_scene_to_file("res://cenas/niveis/tela_vitoria.tscn")
