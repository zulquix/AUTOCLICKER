import time
import threading
import tkinter as tk
from pynput import mouse
from pynput.mouse import Button, Controller

click_interval = 0.0001
clicking = False
bind_button = None
mouse_controller = Controller()

label = None
status_var = None
click_event = threading.Event()

def click_loop():
    global clicking
    next_click = time.perf_counter()
    while True:
        click_event.wait()
        now = time.perf_counter()
        if now >= next_click:
            mouse_controller.click(Button.left)
            next_click = now + click_interval
        else:
            time.sleep(0.00001)

def on_click(x, y, button, pressed):
    global bind_button, clicking
    if bind_button is None and pressed:
        bind_button = button
        print(f"[+] Bound to {bind_button.name.upper()}.")

    if button == bind_button:
        clicking = pressed
        if clicking:
            click_event.set()
        else:
            click_event.clear()
        if status_var:
            status_var.set("Clicking..." if pressed else "Waiting...")

def gui_thread():
    global label, status_var
    root = tk.Tk()
    root.overrideredirect(True)
    root.attributes("-topmost", True)
    root.configure(bg="black")
    root.wm_attributes("-alpha", 0.7)

    screen_width = root.winfo_screenwidth()
    status_var = tk.StringVar(value="Waiting...")
    label = tk.Label(root, textvariable=status_var, font=("Arial", 14), fg="white", bg="black", padx=10, pady=5)
    label.pack()
    root.geometry(f"+{screen_width - 150}+20")

    root.mainloop()

print("[*] Click any mouse button to bind for autoclicking.")
print("[*] Hold the bound button to click extremely fast. Ctrl+C to exit.")

mouse.Listener(on_click=on_click).start()
threading.Thread(target=click_loop, daemon=True).start()
gui_thread()
