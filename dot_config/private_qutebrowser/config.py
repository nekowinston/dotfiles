import catppuccin

config.load_autoconfig()
catppuccin.setup(c, "mocha")

### general stuff
# macOS keybinds :kekw:
c.bindings.commands = {
    "normal": {
        "<Meta+t>": "open -t",
        "<Meta+w>": "tab-close",
        "<Meta+r>": "reload",
        "<Meta+1>": "tab-focus 1",
        "<Meta+2>": "tab-focus 2",
        "<Meta+3>": "tab-focus 3",
        "<Meta+4>": "tab-focus 4",
        "<Meta+5>": "tab-focus 5",
        "<Meta+6>": "tab-focus 6",
        "<Meta+7>": "tab-focus 7",
        "<Meta+8>": "tab-focus 8",
        "<Meta+9>": "tab-focus 9",
        "<Meta+0>": "tab-focus 10",
        "<Meta+q>": "quit",
    }
}
# search when typing in the address bar, and use DDG
c.url.auto_search = "naive"
c.url.searchengines = {"DEFAULT": "https://duckduckgo.com/?q={}"}

### rice
# a teensy bit more padding...
c.statusbar.padding = {"bottom": 4, "left": 4, "right": 4, "top": 4}
c.tabs.padding = {"bottom": 4, "left": 4, "right": 4, "top": 4}
# don't show the tab indicator
c.tabs.indicator.width = 0
## fonts
c.fonts.default_size = "14pt"
# default Comic Code
c.fonts.default_family = "Victor Mono"
# Inter for UI
c.fonts.tabs.selected = "default_size Inter var"
c.fonts.tabs.unselected = "default_size Inter var"
c.fonts.hints = "default_size Inter var"
# uppercase for hints, a la vimium
c.hints.uppercase = True

### other stuff
# use brave blocker + hosts file
c.content.blocking.method = "both"

# self explanatory
c.content.javascript.can_access_clipboard = True
c.content.pdfjs = True

# flags
c.qt.args = [
    "--force-color-profile=srgb",
]

# experimental Privacy-Redirect
from pprint import pprint
import re
from PyQt5.QtCore import QUrl
from qutebrowser.api import interceptor

privacy_mappings = [
    {
        "pattern": r'.*\.youtube.com',
        "redirect": "https://iv.winston.sh",
    }
]

# compile the regexes
privacy_mappings_re = [re.compile(host["pattern"]) for host in privacy_mappings]


def redirect_to_proxies(info: interceptor.Request):
    """keep me productive by redirecting certain hosts"""
    global privacy_mappings
    req_host = info.request_url.host()
    print(info.request_url)

    if any(host.match(req_host) for host in privacy_mappings_re):
        try:
            print([host for host in privacy_mappings_re if host["pattern"].match(req_host)])
            # info.redirect(new_url)
        except:
            pass
        return True


def redirect_80_to_443(info: interceptor.Request):
    url = info.request_url
    scheme = url.scheme()
    req_host = url.host()
    allowlist = [
        "localhost",
        "127.0.0.1"
    ]

    if scheme == "http" and req_host not in allowlist:
        url.setScheme("https")
        try:
            info.redirect(url)
        except:
            pass
        return True


# interceptor.register(redirect_to_proxies)
interceptor.register(redirect_80_to_443)
