#!/usr/bin/env python3
# Quick simulation of ThroatPod scoring logic

score_a = 0
score_b = 0
serving = 'A'
server = 2
game_over = False
history = []

def check_win():
    if score_a >= 11 and score_a - score_b >= 2: return True
    if score_b >= 11 and score_b - score_a >= 2: return True
    return False

def status():
    if game_over:
        winner = 'A' if score_a > score_b else 'B'
        print(f"  *** {winner} WINS! ***  A:{score_a}  B:{score_b}")
    else:
        print(f"  A:{score_a:02d}  B:{score_b:02d}  Srv:{serving}  #{server}")

def rally_won(winner):
    global score_a, score_b, serving, server, game_over
    history.append((score_a, score_b, serving, server))
    if winner == serving:
        if winner == 'A': score_a += 1
        else: score_b += 1
    else:
        if server == 1: server = 2
        else: serving = winner; server = 1
    game_over = check_win()

def undo():
    global score_a, score_b, serving, server, game_over
    if history:
        score_a, score_b, serving, server = history.pop()
        game_over = check_win()
        print("  [undo]")

def reset():
    global score_a, score_b, serving, server, game_over
    history.clear()
    score_a = 0; score_b = 0; serving = 'A'; server = 2; game_over = False
    print("  [reset]")

print("PickleScore Simulator")
print("  a / b  = rally won by A or B")
print("  u      = undo last point")
print("  r      = reset game")
print("  q      = quit")
print()
status()

while True:
    try:
        cmd = input("\n> ").strip().lower()
    except (EOFError, KeyboardInterrupt):
        break
    if cmd == 'q':
        break
    elif cmd == 'a':
        if not game_over: rally_won('A')
        status()
    elif cmd == 'b':
        if not game_over: rally_won('B')
        status()
    elif cmd == 'u':
        undo(); status()
    elif cmd == 'r':
        reset(); status()
    else:
        print("  ? (a/b/u/r/q)")
