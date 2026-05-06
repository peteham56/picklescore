#include <bluefruit.h>

int score_a = 0;
int score_b = 0;
char serving = 'A';
int server = 2;
bool game_over = false;

#define BTN_A  D1
#define BTN_B  D2

#define DEBOUNCE  200   // ms — ignore re-triggers within this window
#define UNDO_MS  1500   // hold ≥ 1.5s → undo last point
#define RESET_MS 3000   // hold ≥ 3.0s → reset game

struct State { int sa, sb; char sv; int sn; };
State history[50];
int hist_len = 0;

bool check_win() {
  if (score_a >= 11 && score_a - score_b >= 2) return true;
  if (score_b >= 11 && score_b - score_a >= 2) return true;
  return false;
}

void save_history() {
  if (hist_len < 50) {
    history[hist_len++] = {score_a, score_b, serving, server};
  }
}

void broadcast() {
  char payload[32];
  snprintf(payload, sizeof(payload), "PS:%02d,%02d,%c,%d",
           score_a % 100, score_b % 100, serving, server % 10);
  uint8_t len = strlen(payload);
  Bluefruit.Advertising.stop();
  delay(50);
  Bluefruit.Advertising.clearData();
  Bluefruit.ScanResponse.clearData();
  Bluefruit.Advertising.setInterval(160, 160);
  Bluefruit.Advertising.addData(0xFF, (uint8_t*)payload, len);
  Bluefruit.Advertising.start(0);
  Serial.println(payload);
}

void rally_won(char winner) {
  save_history();
  if (winner == serving) {
    if (winner == 'A') score_a++;
    else score_b++;
  } else {
    if (server == 1) server = 2;
    else { serving = winner; server = 1; }
  }
  game_over = check_win();
  broadcast();
}

void undo() {
  if (hist_len > 0) {
    State s = history[--hist_len];
    score_a = s.sa; score_b = s.sb;
    serving = s.sv; server = s.sn;
    game_over = check_win();
    broadcast();
  }
}

void reset_game() {
  score_a = 0; score_b = 0;
  serving = 'A'; server = 2;
  hist_len = 0;
  game_over = false;
  broadcast();
}

// Called on button release — dispatches based on hold duration
void handle_release(char team, unsigned long hold_ms) {
  if      (hold_ms >= RESET_MS) reset_game();
  else if (hold_ms >= UNDO_MS)  undo();
  else if (!game_over)          rally_won(team);
}

void setup() {
  Serial.begin(115200);
  delay(1000);
  pinMode(BTN_A, INPUT_PULLUP);
  pinMode(BTN_B, INPUT_PULLUP);
  Bluefruit.begin();
  Bluefruit.setTxPower(4);
  delay(500);
  broadcast();
  Serial.println("PickleScore Throat Pod Ready!");
}

void loop() {
  static unsigned long press_a = 0, press_b = 0;
  static unsigned long last_a = 0, last_b = 0;
  static bool a_active = false, b_active = false;

  unsigned long now = millis();
  bool a_down = (digitalRead(BTN_A) == LOW);
  bool b_down = (digitalRead(BTN_B) == LOW);

  // Button A edge detection
  if (a_down && !a_active && (now - last_a) > DEBOUNCE) {
    a_active = true;
    press_a = now;
  }
  if (!a_down && a_active) {
    a_active = false;
    last_a = now;
    handle_release('A', now - press_a);
  }

  // Button B edge detection
  if (b_down && !b_active && (now - last_b) > DEBOUNCE) {
    b_active = true;
    press_b = now;
  }
  if (!b_down && b_active) {
    b_active = false;
    last_b = now;
    handle_release('B', now - press_b);
  }

  delay(20);
}
