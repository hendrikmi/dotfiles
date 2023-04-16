# Tmux Cheatsheet

## Key Commands

Start a session

```
tmux new -s NewSession
```

Exit session

```
tmux detach
```

List sessions

```
tmux ls
```

Go back into session

```
tmux attach -t NewSession
```

Enable plugins

```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## Shortcuts

Prefix: `CTRL + <Space>`

Create new tmux window: `Prefix + c`

Navigate to window: `Prefix + number`

Cycle through window: `Prefix + n/p`

See all windows: `Prefix + w`

Rename window: `Prefix + ,`

Explore sessions: `Prefix + s`

Install plugins: `Prefix + I`
