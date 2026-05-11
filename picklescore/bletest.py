import subprocess
import time

def broadcast_score(score_a, score_b, serving, server):
    payload = f"PS:A:{score_a},B:{score_b},S:{serving},N:{server}"
    print(f"Broadcasting: {payload}")
    payload_bytes = payload.encode('utf-8')
    hex_payload = ' '.join(f'{b:02x}' for b in payload_bytes)
    length = len(payload_bytes) + 1

    # Disable first
    subprocess.run(['hciconfig', 'hci0', 'noleadv'], capture_output=True)

    # Set advertising data
    adv_data = ['hcitool', '-i', 'hci0', 'cmd', '0x08', '0x0008',
                f'{length:02x}', 'ff'] + hex_payload.split()
    result = subprocess.run(adv_data, capture_output=True)
    print(f"ADV result: {result.returncode}")

    # Enable advertising
    result2 = subprocess.run(['hciconfig', 'hci0', 'leadv', '3'], capture_output=True)
    print(f"LEADV result: {result2.returncode}")
    print("BLE advertising started!")

broadcast_score(5, 3, 'A', 2)
print("Waiting 10 seconds...")
time.sleep(10)
subprocess.run(['hciconfig', 'hci0', 'noleadv'], capture_output=True)
print("Done!")
