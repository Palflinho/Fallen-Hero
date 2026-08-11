base_size = 32;

// Unlike the spike trap, this one runs on a fixed timer regardless of proximity --
// it's a "watch the rhythm and time your pass" hazard rather than a proximity trigger.
state = "hidden";
cycle_time = 2.2;
cycle_timer = random_range(0.5, cycle_time);
telegraph_time = 0.9;
telegraph_timer = 0;
erupt_time = 0.3;
erupt_timer = 0;
damage = 22;
radius = 60;
has_hit = false;
