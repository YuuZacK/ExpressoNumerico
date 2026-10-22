extends Node2D

@onready var hud = $HUD
@onready var caixa_resposta = $CaixaDeResposta
@onready var caixa_calculo = $CaixaCalculo # Referência ao Label da conta

# Define a quantidade total de contas dinâmicas que o jogador precisa resolver
var total_contas: int = 6 
var indice_atual: int = 0
var resultado_atual: int = 0
var aguardando_transicao: bool = false

func _ready() -> void:
	# Inicializa o gerador de números aleatórios para não repetir as mesmas contas
	randomize() 
	carregar_nivel_atual()

## Gera os dados de uma nova conta dinamicamente e atualiza a interface
func carregar_nivel_atual() -> void:
	if indice_atual < total_contas:
		# Geração dinâmica dos números (Ex: de 1 a 10)
		var valor1 = randi_range(1, 10)
		# Garante que valor2 seja menor ou igual a valor1 para evitar resultados negativos
		var valor2 = randi_range(0, valor1) 
		
		# Define o resultado e o texto dinamicamente
		resultado_atual = valor1 - valor2
		caixa_calculo.text = str(valor1) + " - " + str(valor2)
		
		# Prepara a caixa de resposta
		caixa_resposta.text = ""
		caixa_resposta.editable = true
		aguardando_transicao = false
		
		# Atualiza o HUD com pontos e progresso
		hud.atualizar_pontos(Global.pontos)
		hud.atualizar_acertos(Global.acertos, total_contas)
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

	# Validação da resposta comparando com a variável dinâmica
	if new_text != "" and new_text.to_int() == resultado_atual:
		aguardando_transicao = true
		caixa_resposta.editable = false
		
		Global.pontos += 10
		Global.acertos += 1
		
		hud.atualizar_pontos(Global.pontos)
		hud.atualizar_acertos(Global.acertos, total_contas)
		
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
