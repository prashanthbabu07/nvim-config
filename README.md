# nvim-customization

ripgrep is a very fast and efficient command-line tool for searching directories recursively for a regex pattern. Telescope uses it for its live_grep functionality, which allows you to search for text within your project files.
```
brew install ripgrep
```

fd is a simple, fast, and user-friendly alternative to the traditional find command. Telescope can use it for faster and more convenient file finding
```
brew install fd
```


for linux install fd-find and create symbolic link for fd
```
sudo apt install fd-find 
sudo ln -s /usr/bin/fdfind /usr/local/bin/fd
```

Install the Lua formatter:
```
brew install stylua
```

LuaRocks is used to install and manage Lua libraries, and it’s required for certain configurations.
```
brew install luarocks
```

Key bindings 

Ctrl + w h	Move to the left window (Neo-tree)
Ctrl + w l	Move to the right window (file)
Ctrl + w w	Cycle between all open windows

Copy to clipboard
": This tells Neovim you want to use a specific register.
+: This specifies the system clipboard register.
y: This ie yank command.

# Neovim Navigations

<C-w>h : Move to window left
<C-w>l : Move to window right
<C-w>k : Move to window above
<C-w>j : Move to windows below 

# font's

Download fonts from website
https://www.nerdfonts.com/font-downloads

copy to ~/.fonts --copy the font's directory


# Github Copilot 
C-y : Accept suggestion from copilot chat 
#buffer:1 Generate documentation for selection 
