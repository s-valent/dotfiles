import sys
import re
import logging

logger = logging.getLogger()
logger.setLevel(logging.ERROR)

pyversion = sys.version.split()[0]
date = " ".join(re.search("((.*))", sys.version)[0].split(", ")[1].split())

c = get_config()  # pyright: ignore

c.InteractiveShell.banner1 = (
    f"\x1b[1;32mPython {pyversion}\x1b[0m ({date})\n"
    + "Type 'copyright', 'credits' or 'license' for more information, '?' for help.\n"
)
c.InlineBackend.figure_format = "retina"
c.TerminalInteractiveShell.autoformatter = None
c.TerminalInteractiveShell.confirm_exit = False
c.TerminalInteractiveShell.highlighting_style = "bw"
c.TerminalInteractiveShell.prompts_class = "IPython.terminal.prompts.ClassicPrompts"
c.TerminalInteractiveShell.term_title = False

c.InteractiveShellApp.extensions = [
    "autoreload",
    # "line_profiler",
    # "memory_profiler",
]

c.InteractiveShellApp.exec_lines = [
    r"%autoreload 2",
]
