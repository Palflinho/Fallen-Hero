# Sprites dos heróis (pixel art gerada por código)

Os sprites `spr_hero_<classe>_<idle|walk|attack>` são gerados por estes scripts
(48x48, origem em 24,31, virados para a direita — o jogo espelha com `hero_face`).

```
pip install pillow
python sheet.py                 # contact sheet para revisar (sheet_*.png)
python export_gm.py <repo>      # regrava sprites/spr_hero_* e registra no .yyp
```

Para ajustar um personagem, edite a função `draw_<classe>` em `chars.py`
(paleta no dict da classe, poses em IDLE/WALK/ATTACK) e rode o export de novo.
