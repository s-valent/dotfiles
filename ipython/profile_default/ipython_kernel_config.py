c = get_config()  # pyright: ignore
c.HistoryManager.enabled = False

c.InteractiveShellApp.extensions = [
    "autoreload",
]

c.InteractiveShellApp.exec_lines = [
    r"%autoreload 2",
]
