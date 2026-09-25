// =========================================================================
// VERSAO DO JOGO (aparece no canto da tela inicial)
// Formato: MAIOR.MENOR.CORRECAO + estagio
//  - Estagio: Pre-Alpha -> Alpha (tudo jogavel, arte/musica provisorias)
//             -> Beta (conteudo e arte finais, so polimento e bugs) -> lancamento 1.0.0
//  - MENOR sobe a cada entrega de conteudo/sistema para os testadores
//  - CORRECAO sobe quando a entrega so corrige bugs
// =========================================================================
#macro GAME_VERSION "0.1.0"
#macro GAME_STAGE "Alpha"

function game_version_string() {
    return "v" + GAME_VERSION + " " + GAME_STAGE;
}
