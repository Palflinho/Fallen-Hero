// =========================================================================
// SISTEMA DE AUDIO E SINTESE RETRO (Fallen Hero)
// =========================================================================
// Gera efeitos sonoros 16-bit procedurais diretamente via buffers PCM,
// garantindo 0 dependencias externas e resposta sonora instantanea.
// =========================================================================

function audio_system_init() {
    if (variable_global_exists("audio_initialized") && global.audio_initialized) return;
    global.audio_initialized = true;
    global.sfx_volume = 0.85;
    global.sfx_map = {};

    var _sr = 22050; // Taxa de amostragem padrão

    global.sfx_map[$ "slash"] = audio_synth_noise_sweep(0.10, 600, 160, _sr, 0.6);
    global.sfx_map[$ "magic"] = audio_synth_tone_sweep(0.16, 540, 220, "sine", _sr, 0.55);
    global.sfx_map[$ "arrow"] = audio_synth_tone_sweep(0.08, 920, 380, "saw", _sr, 0.45);
    global.sfx_map[$ "dagger"] = audio_synth_noise_sweep(0.06, 1100, 400, _sr, 0.45);
    global.sfx_map[$ "hit"] = audio_synth_hit_crunch(0.09, _sr, 0.65);
    global.sfx_map[$ "parry"] = audio_synth_bell(0.22, 1080, _sr, 0.75);
    global.sfx_map[$ "slam"] = audio_synth_slam_rumble(0.35, _sr, 0.85);
    global.sfx_map[$ "gold"] = audio_synth_chime(0.14, 987, 1318, _sr, 0.55);
    global.sfx_map[$ "chest"] = audio_synth_fanfare(0.32, _sr, 0.7);
    global.sfx_map[$ "stagger"] = audio_synth_bell(0.30, 440, _sr, 0.8);

    // Efeitos de Ambiente da Vila e Portal
    global.sfx_map[$ "bonfire_crackle"] = audio_synth_noise_sweep(0.18, 320, 110, _sr, 0.35);
    global.sfx_map[$ "portal_hum"] = audio_synth_tone_sweep(0.30, 220, 330, "sine", _sr, 0.45);
    global.sfx_map[$ "pedestal_light"] = audio_synth_chime(0.40, 523, 784, _sr, 0.75);

    // Efeitos da Fase 3 (Vento)
    global.sfx_map[$ "wind_gust"] = audio_synth_noise_sweep(0.24, 880, 240, _sr, 0.55);

    // Efeitos do Boss Humano (Templo 5)
    global.sfx_map[$ "laser_beam"] = audio_synth_tone_sweep(0.14, 1200, 320, "saw", _sr, 0.6);
    global.sfx_map[$ "energy_shield"] = audio_synth_bell(0.25, 880, _sr, 0.65);

    // Fonemas da Língua dos Bichinhos e Personagens
    global.sfx_map[$ "voice_tatu"] = audio_synth_tone_sweep(0.05, 200, 130, "saw", _sr, 0.4);
    global.sfx_map[$ "voice_lobo"] = audio_synth_tone_sweep(0.06, 560, 420, "sine", _sr, 0.4);
    global.sfx_map[$ "voice_lagarto"] = audio_synth_noise_sweep(0.04, 1300, 500, _sr, 0.35);
    global.sfx_map[$ "voice_urutau"] = audio_synth_tone_sweep(0.07, 740, 520, "sine", _sr, 0.45);
    global.sfx_map[$ "voice_general"] = audio_synth_tone_sweep(0.08, 160, 80, "saw", _sr, 0.6);
    global.sfx_map[$ "voice_merchant"] = audio_synth_chime(0.06, 680, 880, _sr, 0.4);
    global.sfx_map[$ "voice_elder"] = audio_synth_tone_sweep(0.07, 140, 100, "saw", _sr, 0.45);
    global.sfx_map[$ "voice_human"] = audio_synth_tone_sweep(0.06, 440, 320, "saw", _sr, 0.5);

    // Efeitos de Interface e Vila
    global.sfx_map[$ "menu_select"] = audio_synth_chime(0.12, 784, 1046, _sr, 0.6);
    global.sfx_map[$ "menu_move"] = audio_synth_tone_sweep(0.04, 380, 480, "sine", _sr, 0.35);
    global.sfx_map[$ "door_open"] = audio_synth_tone_sweep(0.20, 150, 90, "saw", _sr, 0.5);
    global.sfx_map[$ "equip"] = audio_synth_fanfare(0.24, _sr, 0.65);

    // Aliases por classe
    global.sfx_map[$ "voice_knight"] = global.sfx_map[$ "voice_tatu"];
    global.sfx_map[$ "voice_mage"] = global.sfx_map[$ "voice_lobo"];
    global.sfx_map[$ "voice_archer"] = global.sfx_map[$ "voice_lagarto"];
    global.sfx_map[$ "voice_assassin"] = global.sfx_map[$ "voice_urutau"];

    // ---------------------------------------------------------------------
    // Inicialização da Trilha Sonora (BGM)
    // ---------------------------------------------------------------------
    if (!variable_global_exists("bgm_initialized") || !global.bgm_initialized) {
        global.bgm_initialized = true;
        global.bgm_volume = variable_global_exists("bgm_volume") ? global.bgm_volume : 0.7;
        global.bgm_current_id = "";
        global.bgm_current_inst = -1;
        global.bgm_current_stream = -1;
        global.bgm_map = {};

        // Síntese procedural de melodias retro em loop contínuo
        global.bgm_map[$ "title"] = audio_synth_bgm_track("title", _sr);
        global.bgm_map[$ "village"] = audio_synth_bgm_track("village", _sr);
        global.bgm_map[$ "dungeon"] = audio_synth_bgm_track("dungeon", _sr);
        global.bgm_map[$ "boss"] = audio_synth_bgm_track("boss", _sr);
    }
}

function sfx_play(_name, _pitch_var = 0.06, _gain_mult = 1.0) {
    audio_system_init();
    if (!variable_struct_exists(global.sfx_map, _name)) return -1;
    var _snd = global.sfx_map[$ _name];
    if (_snd == -1) return -1;
    
    var _inst = audio_play_sound(_snd, 10, false);
    if (_inst != -1) {
        var _pitch = 1.0 + random_range(-_pitch_var, _pitch_var);
        audio_sound_pitch(_inst, max(0.5, _pitch));
        var _master = variable_global_exists("master_volume") ? global.master_volume : 1.0;
        audio_sound_gain(_inst, global.sfx_volume * _gain_mult * _master, 0);
    }
    return _inst;
}

// -------------------------------------------------------------------------
// Motor de BGM (Música de Fundo)
// -------------------------------------------------------------------------
function bgm_play(_track_id, _fade_ms = 400) {
    audio_system_init();
    if (global.bgm_current_id == _track_id && global.bgm_current_inst != -1 && audio_is_playing(global.bgm_current_inst)) {
        return;
    }

    // Fade out suave na faixa anterior
    if (global.bgm_current_inst != -1 && audio_is_playing(global.bgm_current_inst)) {
        audio_sound_gain(global.bgm_current_inst, 0, _fade_ms);
    }

    global.bgm_current_id = _track_id;
    var _snd = -1;

    // 1. Tenta carregar faixa externa (.ogg) caso o desenvolvedor a forneça
    var _ogg_path = "bgm/" + _track_id + ".ogg";
    if (file_exists(_ogg_path)) {
        _snd = audio_create_stream(_ogg_path);
        global.bgm_current_stream = _snd;
    } else if (variable_struct_exists(global.bgm_map, _track_id)) {
        // 2. Fallback automático para a melodia procedural sintetizada em PCM
        _snd = global.bgm_map[$ _track_id];
        global.bgm_current_stream = -1;
    }

    if (_snd != -1) {
        var _inst = audio_play_sound(_snd, 100, true);
        if (_inst != -1) {
            audio_sound_gain(_inst, 0, 0);
            var _master = variable_global_exists("master_volume") ? global.master_volume : 1.0;
            var _target_gain = global.bgm_volume * _master;
            audio_sound_gain(_inst, max(0.001, _target_gain), _fade_ms);
            global.bgm_current_inst = _inst;
        }
    }
}

function bgm_stop(_fade_ms = 400) {
    if (global.bgm_current_inst != -1 && audio_is_playing(global.bgm_current_inst)) {
        audio_sound_gain(global.bgm_current_inst, 0, _fade_ms);
    }
    global.bgm_current_id = "";
}

function bgm_set_volume(_vol) {
    global.bgm_volume = clamp(_vol, 0.0, 1.0);
    if (global.bgm_current_inst != -1 && audio_is_playing(global.bgm_current_inst)) {
        var _master = variable_global_exists("master_volume") ? global.master_volume : 1.0;
        var _target_gain = global.bgm_volume * _master;
        audio_sound_gain(global.bgm_current_inst, max(0.001, _target_gain), 50);
    }
}

function bgm_get_current() {
    return variable_global_exists("bgm_current_id") ? global.bgm_current_id : "";
}

// -------------------------------------------------------------------------
// Funções Internas de Síntese Matemática de Áudio
// -------------------------------------------------------------------------
function audio_synth_tone_sweep(_duration, _start_f, _end_f, _wave, _sr, _gain) {
    var _samples = floor(_duration * _sr);
    var _buf = buffer_create(_samples * 2, buffer_fixed, 1);
    var _phase = 0;
    
    for (var _i = 0; _i < _samples; _i++) {
        var _t = _i / _samples;
        var _freq = lerp(_start_f, _end_f, _t);
        _phase += (2 * pi * _freq) / _sr;
        
        var _val = 0;
        if (_wave == "sine") {
            _val = sin(_phase);
        } else if (_wave == "saw") {
            _val = 2 * ((_phase / (2 * pi)) mod 1) - 1;
        } else { // square
            _val = (sin(_phase) >= 0) ? 1 : -1;
        }
        
        // Envelope suave de ataque e decaimento
        var _env = (1 - _t) * min(1, _i / 100);
        var _s16 = clamp(round(_val * _env * _gain * 32767), -32767, 32767);
        buffer_write(_buf, buffer_s16, _s16);
    }
    
    var _sound = audio_create_buffer_sound(_buf, buffer_s16, _sr, 0, _samples * 2, audio_mono);
    return _sound;
}

function audio_synth_noise_sweep(_duration, _start_f, _end_f, _sr, _gain) {
    var _samples = floor(_duration * _sr);
    var _buf = buffer_create(_samples * 2, buffer_fixed, 1);
    var _last = 0;
    
    for (var _i = 0; _i < _samples; _i++) {
        var _t = _i / _samples;
        var _cutoff = lerp(_start_f, _end_f, _t) / _sr;
        var _white = random_range(-1, 1);
        _last = lerp(_last, _white, min(1, _cutoff * 4));
        
        var _env = (1 - _t) * min(1, _i / 60);
        var _s16 = clamp(round(_last * _env * _gain * 32767), -32767, 32767);
        buffer_write(_buf, buffer_s16, _s16);
    }
    
    var _sound = audio_create_buffer_sound(_buf, buffer_s16, _sr, 0, _samples * 2, audio_mono);
    return _sound;
}

function audio_synth_hit_crunch(_duration, _sr, _gain) {
    var _samples = floor(_duration * _sr);
    var _buf = buffer_create(_samples * 2, buffer_fixed, 1);
    var _phase = 0;
    
    for (var _i = 0; _i < _samples; _i++) {
        var _t = _i / _samples;
        var _freq = lerp(160, 40, _t);
        _phase += (2 * pi * _freq) / _sr;
        var _tone = sin(_phase);
        var _noise = random_range(-1, 1);
        var _val = _tone * 0.6 + _noise * 0.4;
        
        var _env = (1 - _t * _t);
        var _s16 = clamp(round(_val * _env * _gain * 32767), -32767, 32767);
        buffer_write(_buf, buffer_s16, _s16);
    }
    
    var _sound = audio_create_buffer_sound(_buf, buffer_s16, _sr, 0, _samples * 2, audio_mono);
    return _sound;
}

function audio_synth_bell(_duration, _freq, _sr, _gain) {
    var _samples = floor(_duration * _sr);
    var _buf = buffer_create(_samples * 2, buffer_fixed, 1);
    var _p1 = 0;
    var _p2 = 0;
    
    for (var _i = 0; _i < _samples; _i++) {
        var _t = _i / _samples;
        _p1 += (2 * pi * _freq) / _sr;
        _p2 += (2 * pi * (_freq * 2.05)) / _sr;
        var _val = sin(_p1) * 0.7 + sin(_p2) * 0.3;
        
        var _env = exp(-_t * 6);
        var _s16 = clamp(round(_val * _env * _gain * 32767), -32767, 32767);
        buffer_write(_buf, buffer_s16, _s16);
    }
    
    var _sound = audio_create_buffer_sound(_buf, buffer_s16, _sr, 0, _samples * 2, audio_mono);
    return _sound;
}

function audio_synth_slam_rumble(_duration, _sr, _gain) {
    var _samples = floor(_duration * _sr);
    var _buf = buffer_create(_samples * 2, buffer_fixed, 1);
    var _phase = 0;
    
    for (var _i = 0; _i < _samples; _i++) {
        var _t = _i / _samples;
        var _freq = lerp(85, 30, _t);
        _phase += (2 * pi * _freq) / _sr;
        var _rumble = sin(_phase) + sin(_phase * 0.5) * 0.5;
        var _noise = random_range(-0.5, 0.5) * (1 - _t);
        var _val = _rumble * 0.7 + _noise * 0.3;
        
        var _env = exp(-_t * 3.5);
        var _s16 = clamp(round(_val * _env * _gain * 32767), -32767, 32767);
        buffer_write(_buf, buffer_s16, _s16);
    }
    
    var _sound = audio_create_buffer_sound(_buf, buffer_s16, _sr, 0, _samples * 2, audio_mono);
    return _sound;
}

function audio_synth_chime(_duration, _f1, _f2, _sr, _gain) {
    var _samples = floor(_duration * _sr);
    var _buf = buffer_create(_samples * 2, buffer_fixed, 1);
    var _mid = floor(_samples * 0.45);
    var _phase = 0;
    
    for (var _i = 0; _i < _samples; _i++) {
        var _cur_f = (_i < _mid) ? _f1 : _f2;
        _phase += (2 * pi * _cur_f) / _sr;
        var _tone = sin(_phase) * 0.8 + sin(_phase * 2) * 0.2;
        
        var _t_segment = (_i < _mid) ? (_i / _mid) : ((_i - _mid) / (_samples - _mid));
        var _env = exp(-_t_segment * 4);
        var _s16 = clamp(round(_tone * _env * _gain * 32767), -32767, 32767);
        buffer_write(_buf, buffer_s16, _s16);
    }
    
    var _sound = audio_create_buffer_sound(_buf, buffer_s16, _sr, 0, _samples * 2, audio_mono);
    return _sound;
}

function audio_synth_fanfare(_duration, _sr, _gain) {
    var _samples = floor(_duration * _sr);
    var _buf = buffer_create(_samples * 2, buffer_fixed, 1);
    var _notes = [523, 659, 784]; // Dó (C5), Mi (E5), Sol (G5)
    var _seg_len = floor(_samples / 3);
    var _phase = 0;
    
    for (var _i = 0; _i < _samples; _i++) {
        var _note_idx = min(2, floor(_i / _seg_len));
        var _f = _notes[_note_idx];
        _phase += (2 * pi * _f) / _sr;
        var _tone = sin(_phase) * 0.75 + sin(_phase * 3) * 0.25;
        
        var _local_t = (_i mod _seg_len) / _seg_len;
        var _env = exp(-_local_t * 3);
        var _s16 = clamp(round(_tone * _env * _gain * 32767), -32767, 32767);
        buffer_write(_buf, buffer_s16, _s16);
    }
    
    var _sound = audio_create_buffer_sound(_buf, buffer_s16, _sr, 0, _samples * 2, audio_mono);
    return _sound;
}

// -------------------------------------------------------------------------
// Síntese de Trilhas Musicais Procedurais em Loop (BGM)
// -------------------------------------------------------------------------
function audio_synth_bgm_track(_type, _sr) {
    var _duration = 8.0;
    if (_type == "dungeon") _duration = 6.4;
    else if (_type == "boss") _duration = 4.8;
    
    var _samples = floor(_duration * _sr);
    var _buf = buffer_create(_samples * 2, buffer_fixed, 1);
    
    var _p_bass = 0;
    var _p_lead = 0;
    var _p_pad = 0;
    
    for (var _i = 0; _i < _samples; _i++) {
        var _t = _i / _sr;
        var _val = 0;
        
        switch (_type) {
            case "village": {
                // Progressão pacífica e acolhedora: Am -> F -> C -> G (2s por acorde)
                var _bar = floor((_t / 2.0) mod 4);
                var _chord_t = (_t mod 2.0);
                var _f_bass = 110.0; // Am
                var _arp = [220.0, 261.6, 329.6, 440.0];
                
                if (_bar == 1) { // F
                    _f_bass = 87.3;
                    _arp = [174.6, 220.0, 261.6, 349.2];
                } else if (_bar == 2) { // C
                    _f_bass = 130.8;
                    _arp = [130.8, 164.8, 196.0, 261.6];
                } else if (_bar == 3) { // G
                    _f_bass = 98.0;
                    _arp = [196.0, 246.9, 293.7, 392.0];
                }
                
                // Baixo suave
                _p_bass += (2 * pi * _f_bass) / _sr;
                var _bass = sin(_p_bass) * 0.35;
                
                // Arpejo melódico em colcheias (4 notas por acorde)
                var _note_idx = floor((_chord_t / 0.5) mod 4);
                var _f_lead = _arp[_note_idx];
                _p_lead += (2 * pi * _f_lead) / _sr;
                var _note_t = (_chord_t mod 0.5) / 0.5;
                var _lead_env = exp(-_note_t * 3.5);
                var _lead = sin(_p_lead) * _lead_env * 0.28;
                
                _val = _bass + _lead;
                break;
            }
            
            case "dungeon": {
                // Tensão e mistério subterrâneo em Ré Menor
                var _step = floor((_t / 0.4) mod 16);
                var _step_t = (_t mod 0.4) / 0.4;
                var _d_notes = [73.4, 73.4, 110.0, 73.4, 87.3, 73.4, 98.0, 110.0];
                var _f_bass = _d_notes[_step mod 8];
                
                _p_bass += (2 * pi * _f_bass) / _sr;
                var _bass_env = exp(-_step_t * 4);
                var _bass = (sin(_p_bass) + sin(_p_bass * 2) * 0.3) * _bass_env * 0.4;
                
                // Pulso rítmico percussivo sutil (tick subterrâneo)
                var _tick = (random_range(-0.15, 0.15)) * exp(-_step_t * 12);
                
                // Nota atmosférica flutuante
                var _f_pad = (_step < 8) ? 293.7 : 261.6;
                _p_pad += (2 * pi * _f_pad) / _sr;
                var _pad = sin(_p_pad) * 0.12;
                
                _val = _bass + _tick + _pad;
                break;
            }
            
            case "boss": {
                // Ritmo dinâmico e enérgico a 140 BPM (0.43s por batida)
                var _beat_t = (_t mod 0.428) / 0.428;
                var _semi_t = (_t mod 0.107) / 0.107;
                var _bar = floor((_t / 1.714) mod 4);
                var _f_root = (_bar < 2) ? 82.4 : 73.4; // Mi menor / Ré menor
                
                // Bassline 16-bit com dente de serra rápida
                _p_bass += (2 * pi * _f_root) / _sr;
                var _saw = 2 * ((_p_bass / (2 * pi)) mod 1) - 1;
                var _bass = _saw * exp(-_semi_t * 3.0) * 0.32;
                
                // Bumbo rítmico no início de cada batida
                var _kick_f = lerp(130, 35, min(1, _beat_t * 6));
                _p_lead += (2 * pi * _kick_f) / _sr;
                var _kick = sin(_p_lead) * exp(-_beat_t * 6) * 0.45;
                
                // Caixa/estalo de percussão
                var _snare = 0;
                if ((floor(_t / 0.428) mod 2) == 1) {
                    _snare = random_range(-0.25, 0.25) * exp(-_beat_t * 7);
                }
                
                _val = _bass + _kick + _snare;
                break;
            }
            
            default: { // "title"
                // Obertura heroica inspiradora: C -> G -> Am -> F
                var _bar = floor((_t / 2.0) mod 4);
                var _chord_t = (_t mod 2.0);
                var _f_bass = 130.8;
                var _arp = [261.6, 329.6, 392.0, 523.3];
                
                if (_bar == 1) { // G
                    _f_bass = 98.0;
                    _arp = [196.0, 246.9, 293.7, 392.0];
                } else if (_bar == 2) { // Am
                    _f_bass = 110.0;
                    _arp = [220.0, 261.6, 329.6, 440.0];
                } else if (_bar == 3) { // F
                    _f_bass = 87.3;
                    _arp = [174.6, 220.0, 261.6, 349.2];
                }
                
                _p_bass += (2 * pi * _f_bass) / _sr;
                var _bass = (sin(_p_bass) * 0.7 + sin(_p_bass * 0.5) * 0.3) * 0.35;
                
                var _note_idx = floor((_chord_t / 0.25) mod 4);
                var _f_lead = _arp[_note_idx];
                _p_lead += (2 * pi * _f_lead) / _sr;
                var _env = exp(-((_chord_t mod 0.25) / 0.25) * 4);
                var _lead = sin(_p_lead) * _env * 0.3;
                
                _val = _bass + _lead;
                break;
            }
        }
        
        var _s16 = clamp(round(_val * 32767 * 0.8), -32767, 32767);
        buffer_write(_buf, buffer_s16, _s16);
    }
    
    var _sound = audio_create_buffer_sound(_buf, buffer_s16, _sr, 0, _samples * 2, audio_mono);
    return _sound;
}

