# Gerado pelo assistente de configuração do Powerlevel10k em 2026-03-24 às 11:14 -03.
# Baseado em romkatv/powerlevel10k/config/p10k-pure.zsh, checksum 07533.
# Opções do assistente: awesome-patched + powerline + python, ícones pequenos, pure, snazzy,
# rprompt, horário 24h, 2 linhas, compacto, transient_prompt, instant_prompt=verbose.
# Digite `p10k configure` para gerar outra configuração.
#
# Arquivo de configuração para Powerlevel10k com o estilo Pure (https://github.com/sindresorhus/pure).
#
# Diferenças em relação ao Pure:
#
#   - Git:
#     - `@c4d3ec2c` em vez de algo como `v1.4.0~11` quando em estado detached HEAD.
#     - Sem `git fetch` automático (igual ao Pure com `PURE_GIT_PULL=0`).
#
# Além das diferenças listadas acima, a replicação do prompt Pure é exata. Isso inclui
# até as partes questionáveis. Por exemplo, assim como no Pure, não há indicação de status Git
# desatualizado; o símbolo do prompt é o mesmo nos modos comando, visual e sobrescrita do vi; quando
# o prompt não cabe em uma linha, ele quebra sem tentar encurtá-lo.
#
# Se você gosta do estilo geral do Pure mas não está particularmente apegado a todas as suas peculiaridades,
# digite `p10k configure` e escolha o estilo "Lean". Isso dará um prompt minimalista elegante aproveitando
# recursos do Powerlevel10k que não existem no Pure.

# Altera opções temporariamente.
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  # Remove todas as opções de configuração.
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # Zsh >= 5.1 é obrigatório.
  [[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return

  # Cores do prompt.
  local grey='#cccccc'
  local red='#FF5C57'
  local yellow='#F3F99D'
  local blue='#57C7FF'
  local magenta='#FF6AC1'
  local cyan='#9AEDFE'
  local white='#ffff'
  local roxo='#9A9AED'

  # Segmentos do prompt esquerdo.
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    # =========================[ Linha #1 ]=========================
    context                   # usuário@host
    dir                       # diretório atual
    vcs                       # status git
    # command_execution_time  # duração do comando anterior
    # =========================[ Linha #2 ]=========================
    newline                   # \n
    # virtualenv              # ambiente virtual python
    prompt_char               # símbolo do prompt
  )

  # Segmentos do prompt direito.
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    # =========================[ Linha #1 ]=========================
    command_execution_time    # duração do comando anterior
    virtualenv                # ambiente virtual python
    # context                   # usuário@host
    time                      # hora atual
    # =========================[ Linha #2 ]=========================
    newline                   # \n
  )

  # Opções de estilo básicas que definem a aparência geral do prompt.
  typeset -g POWERLEVEL9K_BACKGROUND=                            # fundo transparente
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=  # sem espaços em branco ao redor
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '  # separa segmentos com um espaço
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=        # sem símbolo de fim de linha
  typeset -g POWERLEVEL9K_VISUAL_IDENTIFIER_EXPANSION=           # sem ícones nos segmentos

  # Adiciona uma linha vazia antes de cada prompt exceto o primeiro. Isso não emula o bug
  # do Pure que faz o prompt descer quando você usa o atalho Alt-C do fzf ou similar.
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false

  # Símbolo do prompt magenta se o último comando teve sucesso.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS}_FOREGROUND=$magenta
  # Símbolo do prompt vermelho se o último comando falhou.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS}_FOREGROUND=$red
  # Símbolo padrão do prompt.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  # Símbolo do prompt no modo comando do vi.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  # Símbolo do prompt no modo visual do vi é o mesmo do modo comando.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='❮'
  # Símbolo do prompt no modo sobrescrita do vi é o mesmo do modo comando.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=false

  # Ambiente virtual Python em cinza.
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=$grey
  # Não mostrar versão do Python.
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
  typeset -g POWERLEVEL9K_VIRTUALENV_{LEFT,RIGHT}_DELIMITER=

  # Diretório atual em azul.
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=$blue

  # Formato do contexto quando root: usuário@host. Primeira parte branca, o resto cinza.
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE="Sthevan027"
  # Formato do contexto quando não é root: usuário@host. Tudo em cinza.
  typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE="Sthevan027"
  # Mostra o nome do usuário no prompt (mesmo quando não é root).
  typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_CONTENT_EXPANSION='Sthevan027'
  # Cor do nome no prompt (roxo - combine com o diretório azul).
  typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=$roxo

  # Mostrar duração do comando anterior apenas se for >= 5s.
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=5
  # Não mostrar frações de segundo. Assim, 7s em vez de 7.3s.
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
  # Formato da duração: 1d 2h 3m 4s.
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
  # Duração do comando anterior em amarelo.
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$yellow

  # Prompt Git em cinza. Isso faz prompts desatualizados indistinguíveis dos atualizados.
  typeset -g POWERLEVEL9K_VCS_FOREGROUND=$grey

  # Desabilita indicador de carregamento assíncrono para que diretórios que não são repositórios Git
  # sejam indistinguíveis de repositórios Git grandes sem estado conhecido.
  typeset -g POWERLEVEL9K_VCS_LOADING_TEXT=

  # Não esperar pelo status Git nem por um milissegundo, para que o prompt sempre atualize
  # de forma assíncrona quando o estado do Git mudar.
  typeset -g POWERLEVEL9K_VCS_MAX_SYNC_LATENCY_SECONDS=0

  # Setas à frente/atrás em ciano.
  typeset -g POWERLEVEL9K_VCS_{INCOMING,OUTGOING}_CHANGESFORMAT_FOREGROUND=$cyan
  # Não mostrar branch remota, tag atual ou stashes.
  typeset -g POWERLEVEL9K_VCS_GIT_HOOKS=(vcs-detect-changes git-untracked git-aheadbehind)
  # Não mostrar ícone da branch.
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=
  # Quando em estado detached HEAD, mostrar @commit onde normalmente vai a branch.
  typeset -g POWERLEVEL9K_VCS_COMMIT_ICON='@'
  # Não mostrar indicadores de staged, unstaged, untracked.
  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED}_ICON=
  # Mostrar '*' quando houver arquivos staged, unstaged ou untracked.
  typeset -g POWERLEVEL9K_VCS_DIRTY_ICON='*'
  # Mostrar '⇣' se a branch local está atrás da remota.
  typeset -g POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON=':⇣'
  # Mostrar '⇡' se a branch local está à frente da remota.
  typeset -g POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON=':⇡'
  # Não mostrar o número de commits ao lado das setas à frente/atrás.
  typeset -g POWERLEVEL9K_VCS_{COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=1
  # Remove espaço entre '⇣' e '⇡' e todos os espaços no final.
  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${${${P9K_CONTENT/⇣* :⇡/⇣⇡}// }//:/ }'

  # Hora atual em cinza.
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=$grey
  # Formato da hora atual: 09:51:02. Veja `man 3 strftime`.
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
  # Se true, a hora será atualizada ao pressionar enter. Assim, prompts de comandos
  # passados mostrarão o horário de início dos comandos, não o fim dos comandos anteriores.
  typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false

  # O prompt transitório funciona de forma similar à opção builtin transient_rprompt. Ele reduz o prompt
  # ao aceitar uma linha de comando. Valores suportados:
  #
  #   - off:      Não alterar o prompt ao aceitar uma linha de comando.
  #   - always:   Reduzir o prompt ao aceitar uma linha de comando.
  #   - same-dir: Reduzir o prompt ao aceitar uma linha de comando, exceto se for o primeiro comando
  #               digitado após mudar o diretório de trabalho atual.
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always

  # Modo de prompt instantâneo.
  #
  #   - off:     Desabilita o prompt instantâneo. Escolha isso se tentou e achou incompatível
  #              com seus arquivos de configuração do zsh.
  #   - quiet:   Habilita o prompt instantâneo e não imprime avisos ao detectar saída no console
  #              durante a inicialização do zsh. Escolha isso se leu e entendeu
  #              https://github.com/romkatv/powerlevel10k#instant-prompt.
  #   - verbose: Habilita o prompt instantâneo e imprime um aviso ao detectar saída no console durante
  #              a inicialização do zsh. Escolha isso se nunca tentou o prompt instantâneo, não viu
  #              o aviso, ou se não tem certeza do que isso significa.
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

  # O hot reload permite alterar opções POWERLEVEL9K após o Powerlevel10k ter sido inicializado.
  # Por exemplo, você pode digitar POWERLEVEL9K_BACKGROUND=red e ver seu prompt ficar vermelho. O hot reload
  # pode deixar o prompt 1-2 milissegundos mais lento, então é melhor mantê-lo desligado a menos que
  # você realmente precise.
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

  # Se o p10k já estiver carregado, recarrega a configuração.
  # Funciona mesmo com POWERLEVEL9K_DISABLE_HOT_RELOAD=true.
  (( ! $+functions[p10k] )) || p10k reload
}

# Informa ao `p10k configure` qual arquivo ele deve sobrescrever.
typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
