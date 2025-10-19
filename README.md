```
███╗   ███╗██╗   ██╗    ███████╗███╗   ███╗ █████╗  ██████╗███████╗     ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗ 
████╗ ████║╚██╗ ██╔╝    ██╔════╝████╗ ████║██╔══██╗██╔════╝██╔════╝    ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝ 
██╔████╔██║ ╚████╔╝     █████╗  ██╔████╔██║███████║██║     ███████╗    ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗
██║╚██╔╝██║  ╚██╔╝      ██╔══╝  ██║╚██╔╝██║██╔══██║██║     ╚════██║    ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║
██║ ╚═╝ ██║   ██║       ███████╗██║ ╚═╝ ██║██║  ██║╚██████╗███████║    ╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝
╚═╝     ╚═╝   ╚═╝       ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚══════╝     ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝                                                                                                                     
```
My personal Emacs configuration
Author: Shubhrakamal Saha
License: MIT

Description:
Lightweight Emacs setup for Python, C/C++, Elisp, Shell scripting and Embedded Programming alongwith Org mode for optimized workflows.

Requirements:

* Emacs 28.1 or newer
* JetBrainsMono Nerd Font
* mu4e, isync (mbsync), GPG

Installation:

1. Install dependencies:
   sudo apt install emacs mu4e isync gnupg2 w3m
2. Install JetBrainsMono Nerd Font from nerdfonts.com
3. Backup existing config:
   mv ~/.emacs.d ~/.emacs.d.backup
4. Clone and start Emacs:
   git clone [https://github.com/pickle-lotus0976/emacs-config.git](https://github.com/pickle-lotus0976/emacs-config.git) ~/.emacs.d
   emacs

Org Directory Structure:
~/org/
todos.org
bugs.org
meetings.org
work-log.org
projects/

Key Bindings:
```C-c m``` : mu4e
```C-c c``` : org-capture
```C-c a``` : org-agenda
```C-c l``` : LSP menu
```F8```    : neotree

Troubleshooting:
M-x package-refresh-contents
mbsync -a && mu index
