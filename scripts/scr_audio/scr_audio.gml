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
    global.sfx_map[$ "menu_select"] = audio_synth_chime(0.07, 880, 1175, _sr, 0.4);
    global.sfx_map[$ "victory"] = audio_synth_fanfare(0.70, _sr, 0.8);
    global.sfx_map[$ "thunder"] = audio_synth_slam_rumble(0.65, _sr, 0.9);

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
    global.sfx_map[$ "voice_rino"] = audio_synth_tone_sweep(0.05, 200, 130, "saw", _sr, 0.4);
    global.sfx_map[$ "voice_raposa"] = audio_synth_tone_sweep(0.06, 560, 420, "sine", _sr, 0.4);
    global.sfx_map[$ "voice_lagarto"] = audio_synth_noise_sweep(0.04, 1300, 500, _sr, 0.35);
    global.sfx_map[$ "voice_urutau"] = audio_synth_tone_sweep(0.07, 740, 520, "sine", _sr, 0.45);
    global.sfx_map[$ "voice_general"] = audio_synth_tone_sweep(0.08, 160, 80, "saw", _sr, 0.6);
    global.sfx_map[$ "voice_merchant"] = audio_synth_chime(0.06, 680, 880, _sr, 0.4);
    global.sfx_map[$ "voice_elder"] = audio_synth_tone_sweep(0.07, 140, 100, "saw", _sr, 0.45);
    global.sfx_map[$ "voice_human"] = audio_synth_tone_sweep(0.06, 440, 320, "saw", _sr, 0.5);

    // Aliases por classe
    global.sfx_map[$ "voice_knight"] = global.sfx_map[$ "voice_rino"];
    global.sfx_map[$ "voice_mage"] = global.sfx_map[$ "voice_raposa"];
    global.sfx_map[$ "voice_archer"] = global.sfx_map[$ "voice_lagarto"];
    global.sfx_map[$ "voice_assassin"] = global.sfx_map[$ "voice_urutau"];
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
        audio_sound_gain(_inst, global.sfx_volume * _gain_mult, 0);
    }
    return _inst;
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
