import lgpio
import board
import neopixel
import time
import struct

# BLE broadcast using bluetoothctl
import subprocess

# Pin setup
BUTTON_A = 22
BUTTON_B = 27
BUTTON_U = 23

h = lgpio.gpiochip_open(0)
lgpio.gpio_claim_input(h, BUTTON_A, lgpio.SET_PULL_UP)
lgpio.gpio_claim_input(h, BUTTON_B, lgpio.SET_PULL_UP)
lgpio.gpio_claim_input(h, BUTTON_U, lgpio.SET_PULL_UP)

def read_button(pin):
    return lgpio.gpio_read(h, pin)

# LED matrix setup
NUM_LEDS = 64
PIN = board.D18
pixels = neopixel.NeoPixel(PIN, NUM_LEDS, brightness=0.1, auto_write=False)

# Game state
score_a = 0
score_b = 0
serving_team = 'A'
server_number = 2
history = []
game_over = False

# Debounce
DEBOUNCE = 0.5
last_press_a = time.time()
last_press_b = time.time()
last_press_u = time.time()

# Digit font
DIGITS = {
    '0': [[1,1,1],[1,0,1],[1,0,1],[1,0,1],[1,1,1]],
    '1': [[0,1,0],[1,1,0],[0,1,0],[0,1,0],[1,1,1]],
    '2': [[1,1,1],[0,0,1],[1,1,1],[1,0,0],[1,1,1]],
    '3': [[1,1,1],[0,0,1],[1,1,1],[0,0,1],[1,1,1]],
    '4': [[1,0,1],[1,0,1],[1,1,1],[0,0,1],[0,0,1]],
    '5': [[1,1,1],[1,0,0],[1,1,1],[0,0,1],[1,1,1]],
    '6': [[1,1,1],[1,0,0],[1,1,1],[1,0,1],[1,1,1]],
    '7': [[1,1,1],[0,0,1],[0,1,0],[0,1,0],[0,1,0]],
    '8': [[1,1,1],[1,0,1],[1,1,1],[1,0,1],[1,1,1]],
    '9': [[1,1,1],[1,0,1],[1,1,1],[0,0,1],[1,1,1]],
}

def get_pixel(row, col):
    if col % 2 == 0:
        return col * 8 + row
    else:
        return col * 8 + (7 - row)

def draw_digit(digit, start_col, color):
    pattern = DIGITS[str(digit % 10)]
    for row in range(5):
        for col in range(3):
            if pattern[row][col]:
                idx = get_pixel(row + 1, start_col + col)
                pixels[idx] = color

def show_score_led(team, score):
    pixels.fill((0, 0, 0))
    if team == 'A':
        color = (0, 150, 0)
    else:
        color = (0, 0, 150)
    draw_digit(score, 2, color)
    pixels.show()

def flash_win(team):
    color = (0, 150, 0) if team == 'A' else (0, 0, 150)
    for _ in range(5):
        pixels.fill(color)
        pixels.show()
        time.sleep(0.3)
        pixels.fill((0, 0, 0))
        pixels.show()
        time.sleep(0.3)

def broadcast_ble(score_a, score_b, serving, server):
    try:
        payload = f"PS:A:{score_a},B:{score_b},S:{serving},N:{server}"
        payload_bytes = payload.encode('utf-8')
        hex_payload = ' '.join(f'{b:02x}' for b in payload_bytes)
        length = len(payload_bytes) + 1
        adv_data = ['sudo', 'hcitool', '-i', 'hci0', 'cmd', '0x08', '0x0008',
                    f'{length:02x}', 'ff'] + hex_payload.split()
        subprocess.run(adv_data, capture_output=True)
        subprocess.run(['sudo', 'hciconfig', 'hci0', 'leadv', '3'], capture_output=True)
    except Exception as e:
        print(f"BLE error: {e}")

def display_score():
    print(f"\n--- PickleScore ---")
    print(f"Team A: {score_a}  |  Team B: {score_b}")
    print(f"Serving: Team {serving_team} | Server #{server_number}")
    print(f"------------------")

def check_winner():
    global game_over
    if score_a >= 11 and score_a - score_b >= 2:
        print(f"\n🏆 TEAM A WINS! {score_a}-{score_b} 🏆")
        flash_win('A')
        game_over = True
    elif score_b >= 11 and score_b - score_a >= 2:
        print(f"\n🏆 TEAM B WINS! {score_b}-{score_a} 🏆")
        flash_win('B')
        game_over = True

def save_history():
    history.append((score_a, score_b, serving_team, server_number))

def rally_won(winner):
    global score_a, score_b, serving_team, server_number
    save_history()
    if winner == serving_team:
        if winner == 'A':
            score_a += 1
        else:
            score_b += 1
        print(f"Point for Team {winner}!")
    else:
        if server_number == 1:
            server_number = 2
            print(f"Side out - Server 2 for Team {serving_team}")
        else:
            serving_team = winner
            server_number = 1
            print(f"Side out - Team {winner} now serving!")
    display_score()
    show_score_led(winner, score_a if winner == 'A' else score_b)
    broadcast_ble(score_a, score_b, serving_team, server_number)
    check_winner()

def undo():
    global score_a, score_b, serving_team, server_number, game_over
    if len(history) == 0:
        print("Nothing to undo!")
        return
    score_a, score_b, serving_team, server_number = history.pop()
    game_over = False
    print("Last point undone!")
    display_score()
    show_score_led('A', score_a)
    broadcast_ble(score_a, score_b, serving_team, server_number)

def reset_game():
    global score_a, score_b, serving_team, server_number, history, game_over
    score_a = 0
    score_b = 0
    serving_team = 'A'
    server_number = 2
    history = []
    game_over = False
    print("\nGame Reset!")
    display_score()
    pixels.fill((0, 0, 0))
    pixels.show()
    broadcast_ble(0, 0, 'A', 2)

# Startup
print("PickleScore Ready!")
print("Button A = Team A scores")
print("Button B = Team B scores")
print("Button U = Undo | Hold U 3 seconds = Reset")
display_score()
pixels.fill((0, 0, 0))
pixels.show()
broadcast_ble(score_a, score_b, serving_team, server_number)

try:
    while True:
        now = time.time()

        a_reading = read_button(BUTTON_A)
        b_reading = read_button(BUTTON_B)
        u_reading = read_button(BUTTON_U)

        if not game_over:
            if a_reading == 0 and (now - last_press_a) > DEBOUNCE:
                last_press_a = now
                rally_won('A')
                while read_button(BUTTON_A) == 0:
                    time.sleep(0.01)

            if b_reading == 0 and (now - last_press_b) > DEBOUNCE:
                last_press_b = now
                rally_won('B')
                while read_button(BUTTON_B) == 0:
                    time.sleep(0.01)

        if u_reading == 0 and (now - last_press_u) > DEBOUNCE:
            last_press_u = now
            press_start = time.time()
            while read_button(BUTTON_U) == 0:
                time.sleep(0.01)
            hold_time = time.time() - press_start
            if hold_time >= 3:
                reset_game()
            else:
                undo()

        time.sleep(0.05)

except KeyboardInterrupt:
    print("\nGame Over!")
    print(f"Final Score - Team A: {score_a} | Team B: {score_b}")
    pixels.fill((0, 0, 0))
    pixels.show()
    lgpio.gpiochip_close(h)
